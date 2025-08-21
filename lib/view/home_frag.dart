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
  bool isLoadingMore = false;
  String? nextPageToken;

  late YoutubeApi api;
  late GetVideoReq baseReq;

  @override
  void initState() {
    super.initState();
    api = YoutubeApi();
    baseReq = GetVideoReq(
      part: 'snippet,statistics',
      chart: 'mostPopular',
      maxResults: 20,
      regionCode: 'VN',
      videoCategoryId: '28',
      key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
    );
    loadVideos();
  }

  Future<void> loadVideos() async {
    final result = await api.getPopularVideos(baseReq);

    final fetchedVideos = result.items;
    final channelIds = fetchedVideos.map((v) => v.channelId).toSet().toList();
    final infoMap = await fetchChannelInfos(channelIds);

    setState(() {
      videos = fetchedVideos;
      channelInfoMap = infoMap;
      isLoading = false;
      nextPageToken = result.nextPageToken;
    });
  }

  Future<void> loadMoreVideos() async {
    if (isLoadingMore || nextPageToken == null) return;

    setState(() => isLoadingMore = true);

    final nextReq = baseReq.copyWith(pageToken: nextPageToken);
    final result = await api.getPopularVideos(nextReq);

    final fetchedVideos = result.items;
    final channelIds = fetchedVideos.map((v) => v.channelId).toSet().toList();
    final infoMap = await fetchChannelInfos(channelIds);

    setState(() {
      videos.addAll(fetchedVideos);
      channelInfoMap.addAll(infoMap);
      nextPageToken = result.nextPageToken;
      isLoadingMore = false;
    });
  }

  Future<Map<String, ChannelInfo>> fetchChannelInfos(List<String> channelIds) async {
    final Map<String, ChannelInfo> infoMap = {};
    final utils = CommonUtils();
    const String storageKey = 'cached_channels';

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
            key: baseReq.key,
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
    return infoMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: videos.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == videos.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

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
      ),
    );
  }
}
