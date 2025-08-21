class GetVideoRes {
  final List<VideoItem> items;
  final String? nextPageToken;

  GetVideoRes({
    required this.items,
    this.nextPageToken,
  });

  factory GetVideoRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => VideoItem.fromJson(item)).toList();

    return GetVideoRes(
      items: items,
      nextPageToken: json['nextPageToken'],
    );
  }
}

class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelId;
  final String publishedAt;
  final String viewCount;

  VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelId,
    required this.publishedAt,
    required this.viewCount,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final statistics = json['statistics'] ?? {};

    return VideoItem(
      id: json['id'] is Map
          ? (json['id']['videoId'] ?? '') // trường hợp search API
          : (json['id'] ?? ''), // trường hợp videos API
      title: snippet['title'] ?? '',
      thumbnailUrl: snippet['thumbnails']?['medium']?['url'] ?? '',
      channelId: snippet['channelId'] ?? '',
      publishedAt: snippet['publishedAt'] ?? '',
      viewCount: statistics['viewCount'] ?? '0',
    );
  }
}
