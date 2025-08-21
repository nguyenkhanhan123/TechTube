import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_info_video_req.dart';
import 'package:my_youtube/view/info_video_frag.dart';
import 'package:my_youtube/view/related_video_frag.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../api/youtube_api.dart';
import '../common_utils.dart';
import 'comments_frag.dart';
import 'info_channel_activity.dart';

class ShowVideoAct extends StatefulWidget {
  final String id;

  const ShowVideoAct({super.key, required this.id});

  @override
  State<ShowVideoAct> createState() => _ShowVideoActState();
}

class _ShowVideoActState extends State<ShowVideoAct> {
  final String storageKey = 'cached_channels';
  late final YoutubePlayerController _controller;
  int _currentIndex = 0;

  final List<String> _tabTitles = [
    'Video Information',
    'Related Video',
    'Comments',
  ];

  List<Widget> _fragments = [
    Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
    Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
    Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.id,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    );
    loadInfoVideos();
  }

  Future<void> loadInfoVideos() async {
    final api = YoutubeApi();

    final result = await api.infoVideo(
      GetInfoVideoReq(
        part: 'snippet,statistics',
        id: widget.id,
        key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
      ),
    );

    if (result.items.isEmpty) {
      setState(() {
        _fragments = [
          const Center(child: Text('Không có dữ liệu video')),
          const SizedBox(),
          const SizedBox(),
        ];
      });
      return;
    }

    final video = result.items.first;

    final tags = video.tags ?? [];

    final titleTags = extractHashTags(video.title);
    final descTags = extractHashTags(video.description);

    final mergedTags = {...tags, ...titleTags, ...descTags}.toList();

    mergedTags.shuffle();

    String query = mergedTags.isNotEmpty ? mergedTags.first : video.title;

    setState(() {
      _fragments = [
        InfoVideoFrag(
          item: video,
          onNavigate: () async {
            final channel = await CommonUtils().getChannelById(
              storageKey,
              video.channelId,
            );
            if (channel != null) {
              _controller.pauseVideo();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InfoChannelActivity(id: channel.channelId),
                ),
              );
            }
          },
        ),
        RelatedVideoFrag(querry: query),
        CommentsFrag(id: widget.id),
      ];
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: isSelected ? Colors.blue : Colors.black,
            decoration: isSelected ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            YoutubePlayer(controller: _controller),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tabTitles.length,
                      (index) => _buildTabItem(_tabTitles[index], index),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: IndexedStack(index: _currentIndex, children: _fragments),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> extractHashTags(String? text) {
  if (text == null || text.isEmpty) return [];
  final regex = RegExp(r'#(\w+)');
  return regex
      .allMatches(text)
      .map((m) => m.group(1)!)
      .where((tag) => tag.isNotEmpty)
      .toList();
}

