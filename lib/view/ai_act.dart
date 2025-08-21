import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube/api/ai_api.dart';
import 'package:my_youtube/model/req/send_message_req.dart';
import 'package:my_youtube/view/search_act.dart';

class AIAct extends StatefulWidget {
  @override
  _AIActState createState() => _AIActState();
}

class _AIActState extends State<AIAct> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _visible = true;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text, 'type': 'normal'});
    });
    _controller.clear();
    _scrollToBottom();

    setState(() {
      _messages.add({'role': 'ai', 'text': 'Đang xử lý...', 'type': 'loading'});
    });
    _scrollToBottom();

    final aiReply = await _getAIResponse(text);

    setState(() {
      _messages.removeLast();

      if (text.startsWith('"') && text.endsWith('"')) {
        _messages.add({'role': 'ai', 'text': aiReply, 'type': 'keyword'});
      } else {
        _messages.add({'role': 'ai', 'text': aiReply, 'type': 'normal'});
      }
    });
    _scrollToBottom();
  }

  Future<String> _getAIResponse(String message) async {
    try {
      final api = AIApi();

      if (message.startsWith('"') && message.endsWith('"')) {
        final result = await api.sendMessage(
          SendMessageReq(
            model: 'deepseek/deepseek-r1-0528:free',
            messages: [
              Messages(
                role: 'user',
                content:
                'Hãy chuyển đổi câu hỏi tự nhiên sau : $message thành từ khóa tìm kiếm YouTube phù hợp nhất. '
                    'Nếu như câu hỏi không liên quan đến chủ đề công nghệ thì hãy trả lại cho tôi là '
                    '"Câu hỏi không liên quan đến chủ đề của ứng dung!" '
                    'còn nếu có thì hãy trả lại duy nhất từ khóa và đóng gói trong dấu * * và không được có thêm các câu trả lời gì thêm.',
              ),
            ],
          ),
        );
        return result.content;
      } else {
        final result = await api.sendMessage(
          SendMessageReq(
            model: 'deepseek/deepseek-r1-0528:free',
            messages: [
              Messages(role: 'user', content: message),
            ],
          ),
        );
        return result.content;
      }
    } catch (e) {
      return 'Không thể kết nối đến server.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageText(
      String text, bool isKeyword, bool isAI, BuildContext context) {
    final regex = RegExp(r'\*(.*?)\*');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return SelectableText(
        text,
        style: TextStyle(
          fontWeight: isKeyword ? FontWeight.bold : FontWeight.normal,
          color: isKeyword ? Colors.blue.shade900 : Colors.black,
          fontSize: isKeyword ? 16 : 14,
        ),
      );
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(color: Colors.black, fontSize: 14),
        ));
      }

      final highlighted = match.group(1)!;
      spans.add(
        TextSpan(
          text: highlighted,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          recognizer: isAI
              ? (TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchAct(initialQuery:highlighted)),
              );
            })
              : null,
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(color: Colors.black, fontSize: 14),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/ic_logo.png', height: 38),
            SizedBox(width: 12),
            Text(
              'TechTubeAI',
              style: TextStyle(
                fontFamily: 'Rocker',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Offstage(
            offstage: !_visible,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hãy đặt ra câu hỏi của bạn, AI để chuyển đổi câu hỏi tự nhiên thành từ khóa tìm kiếm trong TechTube khi bạn nhắn tin đóng gói bằng dấu " "! Còn không cứ nhắn tin với AI như bình thươờng nhé!',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        _visible = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                final isKeyword = msg['type'] == 'keyword';

                return Container(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildMessageText(
                      msg['text'] ?? '',
                      isKeyword,
                      !isUser, // chỉ cho AI clickable
                      context,
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.black,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Viết câu hỏi của bạn vào đây!',
                      filled: true,
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
