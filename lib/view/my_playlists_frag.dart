import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_info_channel_req.dart';
import 'package:my_youtube/model/req/get_my_playlists_req.dart';
import 'package:my_youtube/model/req/get_video_req.dart';
import 'package:my_youtube/model/res/get_playlists_res.dart';
import 'package:my_youtube/model/res/get_video_res.dart';
import 'package:my_youtube/view/item_playlists.dart';
import 'package:my_youtube/view/item_video.dart';

import '../api/youtube_api.dart';
import '../common_utils.dart';

class MyPlaylistsFrag extends StatefulWidget {
  @override
  _MyPlaylistsFragState createState() => _MyPlaylistsFragState();
}

class _MyPlaylistsFragState extends State<MyPlaylistsFrag> {
  List<PlaylistsItem> playlists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    setState(() {
      isLoading = true;
    });

    final api = YoutubeApi();
    final accessToken = await CommonUtils().getPref("accessToken");

    if (accessToken == null || accessToken.isEmpty) {
      setState(() {
        playlists = [];
        isLoading = false;
      });
      return;
    }

    final result = await api.getMyPlaylistWithToken(
      GetMyPlaylistsReq(part: 'snippet,contentDetails', mine: true),
      accessToken.toString(),
    );

    setState(() {
      playlists = result.items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : RefreshIndicator(
        onRefresh: loadPlaylists,
        child: ListView.builder(
          key: PageStorageKey('myPlaylistsList'),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final list = playlists[index];
            return ItemPlaylist(
              title: list.title,
              thumbnailUrl: list.thumbnailUrl,
              channelName: list.channelTitle,
              itemCount: list.itemCount,
            );
          },
        ),
      ),
    );
  }
}
