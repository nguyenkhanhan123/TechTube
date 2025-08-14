import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_cmt_video_req.dart';
import 'package:my_youtube/model/req/send_cmt_req.dart';
import 'package:my_youtube/view/item_comments.dart';
import '../api/youtube_api.dart';
import '../common_utils.dart';
import '../model/res/get_cmt_video_res.dart';

class CommentsFrag extends StatefulWidget {
  final String id;

  const CommentsFrag({super.key, required this.id});

  @override
  _CommentsFragState createState() => _CommentsFragState();
}

class _CommentsFragState extends State<CommentsFrag> {
  List<CommentItem> cmts = [];
  bool isLoading = true;
  String? photoUrl;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCmts();
    loadAvatar();
  }

  Future<void> loadCmts() async {
    final api = YoutubeApi();

    try {
      final result = await api.cmtVideo(
        GetCmtVideoReq(
          part: 'snippet',
          maxResults: 99,
          key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
          videoId: widget.id,
        ),
      );

      setState(() {
        cmts = result.items;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải bình luận: $e')),
      );
    }
  }

  Future<void> loadAvatar() async {
    final url = await CommonUtils().getPref("photoUrl");
    setState(() {
      photoUrl = url;
    });
  }

  void _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final api = YoutubeApi();
    final accessToken = await CommonUtils().getPref("accessToken");

    try {
      final result = await api.postCmtWithToken(
        SendCmtReq(
          text: text,
          videoId: widget.id,
        ),
        accessToken.toString()
      );

      _controller.clear();
      FocusScope.of(context).unfocus();

      Future.delayed(Duration(seconds: 25), () async {
        setState(() {
          isLoading = true;
        });

        await loadCmts();
      });

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đăng bình luận: $e')),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Column(
        children: [
          Expanded(
            child: cmts.isEmpty
                ? Center(child: Text('Không có bình luận nào'))
                : ListView.builder(
              itemCount: cmts.length,
              itemBuilder: (context, index) {
                final cmt = cmts[index];
                return ItemComment(comment: cmt);
              },
            ),
          ),
          Divider(height: 1),
          _buildMyCommentBar(),
        ],
      ),
    );
  }

  Widget _buildMyCommentBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : AssetImage('assets/avatar_placeholder.png') as ImageProvider,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Viết bình luận...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blueAccent),
              onPressed: _submitComment,
            ),
          ],
        ),
      ),
    );
  }
}
