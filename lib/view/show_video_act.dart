import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_info_video_req.dart';
import 'package:my_youtube/view/info_video_frag.dart';
import 'package:my_youtube/view/related_video_frag.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../api/youtube_api.dart';
import 'comments_frag.dart';

class ShowVideoAct extends StatefulWidget {
  final String id;

  const ShowVideoAct({super.key, required this.id});

  @override
  State<ShowVideoAct> createState() => _ShowVideoActState();
}

class _ShowVideoActState extends State<ShowVideoAct> {
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

    setState(() {
      _fragments = [
        InfoVideoFrag(item: result.items.first),
        RelatedVideoFrag(querry: handleStringList(result.items.first.tags)),
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

String handleStringList(List<String> items) {
  if (items.isEmpty) return '';

  if (items.length <= 3) {
    return items.join(' ');
  }

  final middleIndex = items.length ~/ 2;
  return '${items.first} ${items[middleIndex]} ${items.last}';
}
