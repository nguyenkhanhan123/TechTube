import 'package:flutter/material.dart';

import '../common_utils.dart';
import '../db/db.dart';

class ItemVideo2 extends StatelessWidget {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String publishedAt;

  const ItemVideo2({
    super.key,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.publishedAt
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final email = await CommonUtils().getPref("email");
        if (email == null || email.isEmpty) {
          return;
        }
        DB().insertOrReplaceWatchedVideoWithEmail(email: email, videoId: id, title: title, thumbnailUrl: thumbnailUrl, channelName: channelName, publishedAt: publishedAt);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 8, 5, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnailUrl,
                width: 150,
                height: 84,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$channelName · ${formatPublishedTime(publishedAt)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Nunito',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.more_vert),
          ],
        ),
      ),
    );
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
