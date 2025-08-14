import 'package:flutter/material.dart';
import 'package:my_youtube/common_utils.dart';
import 'package:my_youtube/model/res/get_info_video_res.dart';

import '../model/res/get_info_channel_res.dart';

class InfoVideoFrag extends StatefulWidget {
  final InfoVideoItem item;

  const InfoVideoFrag({super.key, required this.item});

  @override
  _InfoVideoFragState createState() => _InfoVideoFragState();
}

class _InfoVideoFragState extends State<InfoVideoFrag> {
  final String storageKey = 'cached_channels';
  late ChannelInfoItem localChannel;
  bool _isLoadingChannel = true;

  @override
  void initState() {
    super.initState();
    _loadChannel();
  }

  Future<void> _loadChannel() async {
    final channel = await CommonUtils().getChannelById(
      storageKey,
      widget.item.channelId,
    );
    if (channel != null) {
      setState(() {
        localChannel = channel;
        _isLoadingChannel = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingChannel) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 12),

          // Channel info
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(localChannel.thumbnailUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localChannel.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatNumber(localChannel.subscriberCount)} người đăng ký',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Xem kênh',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),

            ],
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox(
                title: formatNumber(widget.item.likeCount),
                subtitle: 'Lượt thích',
              ),
              _buildStatBox(
                title: formatNumber(widget.item.viewCount),
                subtitle: 'Lượt xem',
              ),
              _buildStatBox(
                title: getYearFromIso(widget.item.publishedAt),
                subtitle: getDayMonthFromIso(widget.item.publishedAt),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tags
          if (widget.item.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.item.tags.map((tag) {
                    return GestureDetector(
                      onTap: null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Nunito',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

          const SizedBox(height: 16),

          if (widget.item.description.trim().isNotEmpty)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.item.description,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Nunito'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBox({required String title, required String subtitle}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
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

String getYearFromIso(String isoTime) {
  final date = DateTime.parse(isoTime);
  return date.year.toString();
}

String getDayMonthFromIso(String isoTime) {
  final date = DateTime.parse(isoTime);
  return '${date.day} thg ${date.month}';
}
