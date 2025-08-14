class GetCmtVideoRes {
  final List<CommentItem> items;

  GetCmtVideoRes({required this.items});

  factory GetCmtVideoRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items = itemsJson.map((e) => CommentItem.fromJson(e)).toList();
    return GetCmtVideoRes(items: items);
  }
}

class CommentItem {
  final String authorName;
  final String authorProfileImageUrl;
  final String authorChannelId;
  final String commentText;
  final String publishedAt;

  CommentItem({
    required this.authorName,
    required this.authorProfileImageUrl,
    required this.authorChannelId,
    required this.commentText,
    required this.publishedAt,
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet']?['topLevelComment']?['snippet'] ?? {};
    final channelIdMap = snippet['authorChannelId'] ?? {};

    return CommentItem(
      authorName: snippet['authorDisplayName'] ?? '',
      authorProfileImageUrl: snippet['authorProfileImageUrl'] ?? '',
      authorChannelId: channelIdMap['value'] ?? '',
      commentText: snippet['textOriginal'] ?? '',
      publishedAt: snippet['publishedAt'] ?? '',
    );
  }
}
