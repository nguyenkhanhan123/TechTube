import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_info_channel_req.dart';
import 'package:my_youtube/view/item_video.dart';

import '../api/youtube_api.dart';
import '../common_utils.dart';
import '../model/req/get_view_video_req.dart';
import '../model/req/search_video_req.dart';
import '../model/video.dart';
import 'home_frag.dart';

class RelatedVideoFrag extends StatefulWidget {
  final String querry;

  const RelatedVideoFrag({super.key, required this.querry});
  @override
  _RelatedVideoFragState createState() => _RelatedVideoFragState();
}

class _RelatedVideoFragState extends State<RelatedVideoFrag> {
  List<Video> videos = [];
  bool isLoading = true;
  String q='';

  @override
  void initState() {
    super.initState();

    if(widget.querry==''){
      q='công nghệ thú vị';
    }
    else{
      q=widget.querry;
    }

    loadVideos();
  }

  Future<void> loadVideos() async {
    final api = YoutubeApi();

    final result = await api.searchVideo(
      SearchVideoReq(
        part: 'snippet',
        q: q,
        type: 'video',
        maxResults: 10,
        regionCode: 'VN',
        videoCategoryId: '28',
        key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
      ),
    );

    final fetchedVideos = result.items;

    final videoIds = fetchedVideos.map((v) => v.id).toList();

    final statsRes = await api.viewVideo(
      GetViewVideoReq(
        part: 'statistics',
        id: videoIds.join(','),
        key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
      ),
    );

    final Map<String, String> videoStatsMap = {
      for (var item in statsRes.items) item.id: item.viewCount ?? '0',
    };

    final channelIds = fetchedVideos.map((v) => v.channelId).toSet().toList();

    final utils = CommonUtils();
    final String storageKey = 'cached_channels';

    final Map<String, ChannelInfo> infoMap = {};

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
      videos =
          fetchedVideos.map((item) {
            return Video(
              id: item.id ?? '',
              title: item.title ?? '',
              thumbnailUrl: item.thumbnailUrl ?? '',
              publishedAt: item.publishedAt ?? '',
              viewCount: videoStatsMap[item.id] ?? '0',
              channelUrl: infoMap[item.channelId]?.avatarUrl ?? '',
              channelName: infoMap[item.channelId]?.title ?? '',
            );
          }).toList();
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
              : ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];

                  return ItemVideo(
                    id: video.id,
                    title: video.title,
                    thumbnailUrl: video.thumbnailUrl,
                    publishedAt: video.publishedAt,
                    viewCount: video.viewCount,
                    channelUrl: video.channelUrl,
                    channelName: video.channelName,
                  );
                },
              ),
    );
  }
}
