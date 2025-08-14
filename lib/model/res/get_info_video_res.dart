class GetInfoVideoRes {
  final List<InfoVideoItem> items;

  GetInfoVideoRes({required this.items});

  factory GetInfoVideoRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => InfoVideoItem.fromJson(item)).toList();
    return GetInfoVideoRes(items: items);
  }
}

class InfoVideoItem {
  final String title;
  final String description;
  final String viewCount;
  final String likeCount;
  final String publishedAt;
  final List<String> tags;
  final String channelId;

  InfoVideoItem({
    required this.title,
    required this.description,
    required this.viewCount,
    required this.likeCount,
    required this.publishedAt,
    required this.tags,
    required this.channelId,
  });

  factory InfoVideoItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final statistics = json['statistics'] ?? {};

    return InfoVideoItem(
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      viewCount: statistics['viewCount'] ?? '0',
      likeCount: statistics['likeCount'] ?? '0',
      publishedAt: snippet['publishedAt'] ?? '',
      tags: List<String>.from(snippet['tags'] ?? []),
      channelId: snippet['channelId'] ?? '',
    );
  }
}
