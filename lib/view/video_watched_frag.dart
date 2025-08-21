import 'package:flutter/material.dart';

import '../common_utils.dart';
import '../db/db.dart';
import 'item_video2.dart';

class VideoWatchedFrag extends StatefulWidget {
  @override
  _VideoWatchedFragState createState() => _VideoWatchedFragState();
}

class _VideoWatchedFragState extends State<VideoWatchedFrag> {
  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadVideos();
  }

  Future<void> loadVideos() async {
    final email = await CommonUtils().getPref("email");
    final result = await DB().getWatchedVideosByEmail(email.toString());

    setState(() {
      videos = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : videos.isEmpty
              ? Center(child: Text("Bạn chưa xem video nào"))
              : RefreshIndicator(
                onRefresh: loadVideos,
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ItemVideo2(
                      id: video['videoId'] ?? '',
                      title: video['title'] ?? '',
                      thumbnailUrl: video['thumbnailUrl'] ?? '',
                      publishedAt: video['publishedAt'] ?? '',
                      channelName: video['channelName'] ?? '',
                    );
                  },
                ),
              ),
    );
  }
}
