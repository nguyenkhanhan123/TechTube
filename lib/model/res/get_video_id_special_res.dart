class GetVideoIdSpecialRes {
  final List<VideoItem2> items;

  GetVideoIdSpecialRes({required this.items});

  factory GetVideoIdSpecialRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => VideoItem2.fromJson(item)).toList();
    return GetVideoIdSpecialRes(items: items);
  }
}

class VideoItem2 {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;

  VideoItem2({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
  });

  factory VideoItem2.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final resourceId = snippet['resourceId'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final contentDetails = json['contentDetails'];

    return VideoItem2(
      id: resourceId['videoId'] ?? '',
      title: snippet['title'] ?? '',
      thumbnailUrl: thumbnails['medium']?['url'] ?? '',
      channelTitle: snippet['channelTitle'] ?? '',
      publishedAt: contentDetails['videoPublishedAt'] ?? '',
    );
  }
}
