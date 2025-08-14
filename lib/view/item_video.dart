import 'package:flutter/material.dart';
import 'package:my_youtube/view/show_video_act.dart';

import '../common_utils.dart';
import '../db/db.dart';

class ItemVideo extends StatelessWidget {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelUrl;
  final String channelName;
  final String publishedAt;
  final String viewCount;

  const ItemVideo({
    super.key,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.viewCount,
    required this.channelUrl,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width * 9 / 16;

    return InkWell(
      onTap: () async {
        final email = await CommonUtils().getPref("email");
        if (email == null || email.isEmpty) {
          return;
        }

        await DB().insertOrReplaceWatchedVideoWithEmail(
          email: email,
          videoId: id,
          title: title,
          thumbnailUrl: thumbnailUrl,
          channelName: channelName,
          publishedAt: publishedAt,
        );

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowVideoAct(id: id)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Image.network(
            thumbnailUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(channelUrl),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    Text(
                      '$channelName • ${formatViewCount(viewCount)} • ${formatPublishedTime(publishedAt)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Nunito',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

String formatViewCount(String viewCount) {
  final count = int.tryParse(viewCount) ?? 0;
  if (count >= 1_000_000_000) {
    return '${(count / 1_000_000_000).toStringAsFixed(1)}B views';
  } else if (count >= 1_000_000) {
    return '${(count / 1_000_000).toStringAsFixed(1)}M views';
  } else if (count >= 1_000) {
    return '${(count / 1_000).toStringAsFixed(1)}K views';
  } else {
    return '$count views';
  }
}

String formatPublishedTime(String publishedAt) {
  final publishedDate = DateTime.tryParse(publishedAt)?.toLocal();
  if (publishedDate == null) return '';

  final now = DateTime.now();
  final diff = now.difference(publishedDate);

  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  } else if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else if (diff.inDays >= 7) {
    final weeks = (diff.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
