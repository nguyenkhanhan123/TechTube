import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_youtube/api/youtube_api.dart';
import 'package:my_youtube/view/video_special_id_frag.dart';

import '../model/req/get_info_channel_req.dart';
import '../model/res/get_info_channel_res2.dart';
import 'ai_act.dart';
import 'channel_playlists_frag.dart';

class InfoChannelActivity extends StatefulWidget {
  final String id;
  const InfoChannelActivity({super.key, required this.id});

  @override
  _InfoChannelActivityState createState() => _InfoChannelActivityState();
}

class _InfoChannelActivityState extends State<InfoChannelActivity> {
  GetInfoChannelRes2? channel;
  int _currentIndex = 0;
  List<Widget> _fragments = [
    Center(
      child: Text("Fragment Video đã đăng", style: TextStyle(fontSize: 18)),
    ),
    Center(
      child: Text("Fragment Danh sách phát", style: TextStyle(fontSize: 18)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInfoChannel();
  }

  Future<void> _loadInfoChannel() async {
    final req = GetInfoChannelReq(
      part: 'snippet,contentDetails,statistics',
      id: widget.id,
      key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
    );

    final res = await YoutubeApi().getInfoChannel2(req);
    setState(() {
      _fragments = [
        VideoSpecialIdFrag(playlistId: convertIdToUU(res.id)),
        ChannelPlaylistsFrag(id: widget.id),
      ];
      channel = res;
    });
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
              'TechTube',
              style: TextStyle(
                fontFamily: 'Rocker',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIAct()),
                );
              },
              icon: Icon(Icons.psychology, size: 32, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin kênh
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          channel?.avatarUrl != null
                              ? NetworkImage(channel!.avatarUrl!)
                              : null,
                      child:
                          channel?.avatarUrl == null
                              ? Icon(Icons.person, size: 32, color: Colors.grey)
                              : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channel?.title ?? "Đang tải...",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (channel != null)
                            Text(
                              "${formatNumber(channel!.subscriberCount.toString())} subscribers • ${formatNumber(channel!.videoCount.toString())} videos • ${formatNumber(channel!.viewCount.toString())} views",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          if (channel?.customUrl != null ||
                              channel?.publishedAt != null ||
                              channel?.id != null)
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              trailing: Icon(
                                Icons.expand_more,
                                color: Colors.blue,
                              ),
                              title: Text(
                                "Xem thêm",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                ),
                              ),
                              children: [
                                if (channel?.description != null &&
                                    channel!.description!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      channel!.description!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                if (channel?.customUrl != null)
                                  Text(
                                    "URL: ${channel!.customUrl}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                if (channel?.publishedAt != null)
                                  Text(
                                    "Tạo ngày: ${_formatDate(channel!.publishedAt!)}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                if (channel?.id != null)
                                  Text(
                                    "ID: ${channel!.id}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildTabButton("Video đã đăng", 0),
                  _buildTabButton("Danh sách phát", 1),
                ],
              ),
            ),

            SizedBox(height: 12),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IndexedStack(index: _currentIndex, children: _fragments),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? Radius.circular(10) : Radius.zero,
              right: index == 1 ? Radius.circular(10) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  String convertIdToUU(String id) {
    if (id.length < 2) return id;
    return 'UU${id.substring(2)}';
  }
}

String formatNumber(String countStr) {
  final count = int.tryParse(countStr) ?? 0;
  if (count >= 1_000_000_000) {
    return '${(count / 1_000_000_000).toStringAsFixed(1)}B';
  } else if (count >= 1_000_000) {
    return '${(count / 1_000_000).toStringAsFixed(1)}M';
  } else if (count >= 1_000) {
    return '${(count / 1_000).toStringAsFixed(1)}K';
  } else {
    return '$count';
  }
}
