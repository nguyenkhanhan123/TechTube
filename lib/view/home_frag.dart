import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_info_channel_req.dart';
import 'package:my_youtube/model/req/get_video_req.dart';
import 'package:my_youtube/model/res/get_video_res.dart';
import 'package:my_youtube/view/item_video.dart';

import '../api/youtube_api.dart';
import '../common_utils.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class ChannelInfo {
  final String avatarUrl;
  final String title;

  ChannelInfo({required this.avatarUrl, required this.title});
}

class _HomeFragmentState extends State<HomeFragment> {
  List<VideoItem> videos = [];
  Map<String, ChannelInfo> channelInfoMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> loadVideos() async {
    final api = YoutubeApi();

    final result = await api.getPopularVideos(
      GetVideoReq(
        part: 'snippet,statistics',
        chart: 'mostPopular',
        maxResults: 99,
        regionCode: 'VN',
        videoCategoryId: '28',
        key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
      ),
    );

    final fetchedVideos = result.items;

    final channelIds = fetchedVideos.map((v) => v.channelId).toSet().toList();

    final Map<String, ChannelInfo> infoMap = {};

    final utils = CommonUtils();
    final String storageKey = 'cached_channels';

    for (final id in channelIds) {
      final localChannel = await utils.getChannelById(storageKey, id);

      if (localChannel != null) {
        infoMap[id] = ChannelInfo(
          avatarUrl: localChannel.thumbnailUrl ?? '',
          title: localChannel.title ?? '',
        );
        continue;
      }

      try {
        final channelRes = await api.getInfoChannel(
          GetInfoChannelReq(
            part: 'snippet,statistics',
            id: id,
            key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
          ),
        );

        if (channelRes.items.isNotEmpty) {
          final item = channelRes.items.first;

          await utils.saveUniqueChannelToList(storageKey, item);

          infoMap[id] = ChannelInfo(
            avatarUrl: item.thumbnailUrl ?? '',
            title: item.title ?? '',
          );
        }
      } catch (e) {
        infoMap[id] = ChannelInfo(avatarUrl: '', title: '');
      }
    }

    setState(() {
      videos = fetchedVideos;
      channelInfoMap = infoMap;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator( color: Colors.blueAccent))
              : ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  final channel = channelInfoMap[video.channelId];

                  return ItemVideo(
                    id: video.id,
                    title: video.title,
                    thumbnailUrl: video.thumbnailUrl,
                    publishedAt: video.publishedAt,
                    viewCount: video.viewCount,
                    channelUrl: channel?.avatarUrl ?? '',
                    channelName: channel?.title ?? '',
                  );
                },
              ),
    );
  }
}
