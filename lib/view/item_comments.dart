import 'package:flutter/material.dart';
import '../model/res/get_cmt_video_res.dart';

class ItemComment extends StatelessWidget {
  final CommentItem comment;

  const ItemComment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.authorProfileImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatPublishedTime(comment.publishedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.commentText,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
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
