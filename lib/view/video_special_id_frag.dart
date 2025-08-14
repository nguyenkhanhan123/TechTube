import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_video_id_special_req.dart';

import '../api/youtube_api.dart';
import '../common_utils.dart';
import '../model/res/get_video_id_special_res.dart';
import 'item_video2.dart';

class VideoSpecialIdFrag extends StatefulWidget {
  final String playlistId;

  const VideoSpecialIdFrag({super.key, required this.playlistId});

  @override
  _VideoSpecialIdFragState createState() => _VideoSpecialIdFragState();
}

class _VideoSpecialIdFragState extends State<VideoSpecialIdFrag> {
  List<VideoItem2> videos = [];
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
    final api = YoutubeApi();
    final accessToken = await CommonUtils().getPref("accessToken");

    final result = await api.getVideoWithSpecialId(
      GetVideoIdSpecialReq(
        part: 'snippet,contentDetails',
        playlistId: widget.playlistId,
        maxResults: 50,
      ),
      accessToken.toString(),
    );

    setState(() {
      videos = result.items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : videos.isEmpty
          ? Center(child: Text("Không có video nào trong playlist"))
          : RefreshIndicator(
        onRefresh: loadVideos,
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return ItemVideo2(
              id: video.id,
              title: video.title,
              thumbnailUrl: video.thumbnailUrl,
              publishedAt: video.publishedAt,
              channelName: video.channelTitle ?? '',
            );
          },
        ),
      ),
    );
  }
}
