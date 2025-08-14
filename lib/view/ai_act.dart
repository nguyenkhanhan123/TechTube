import 'package:flutter/material.dart';
import 'package:my_youtube/api/ai_api.dart';
import 'package:my_youtube/model/req/send_message_req.dart';

class AIAct extends StatefulWidget {
  @override
  _AIActState createState() => _AIActState();
}

class _AIActState extends State<AIAct> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _visible = true;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
    });
    _controller.clear();

    setState(() {
      _messages.add({'role': 'ai', 'text': 'Đang xử lý...'});
    });

    final aiReply = await _getAIResponse(text);

    setState(() {
      _messages.removeLast();
      _messages.add({'role': 'ai', 'text': aiReply});
    });

  }

  Future<String> _getAIResponse(String message) async {
    try{
    final api = AIApi();
    final result = await api.sendMessage(
      SendMessageReq(
        model: 'deepseek/deepseek-r1-0528:free',
        messages: [Messages(role: 'user', content: 'Hãy chuyển đổi câu hỏi tự nhiên sau : "$message" thành từ khóa tìm kiếm YouTube phù hợp nhất. Nếu như nó không liên quan đến công nghệ thì hãy trả lại cho tôi là "Câu hỏi không liên quan đến chủ đề của ứng dung!" còn nếu có thì hãy trả lại duy nhất từ khóa và không nói gì thêm.')],
      ),
    );
    final content = result.content;
    return content;
    }
    catch(e) {
      return 'Không thể kết nối đến server.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      'Hãy đặt ra câu hỏi của bạn, AI để chuyển đổi câu hỏi tự nhiên thành từ khóa tìm kiếm trong TechTube!',
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
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
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
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                      border: UnderlineInputBorder(), // KHÔI PHỤC gạch chân
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  )
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
