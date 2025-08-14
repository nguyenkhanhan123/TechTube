class GetInfoChannelRes2 {
  final String id;
  final String title;
  final String? description;
  final String? customUrl;
  final String? publishedAt;
  final String? avatarUrl;
  final String? uploadsPlaylistId;
  final int viewCount;
  final int subscriberCount;
  final int videoCount;

  GetInfoChannelRes2({
    required this.id,
    required this.title,
    this.description,
    this.customUrl,
    this.publishedAt,
    this.avatarUrl,
    this.uploadsPlaylistId,
    required this.viewCount,
    required this.subscriberCount,
    required this.videoCount,
  });

  factory GetInfoChannelRes2.fromJson(Map<String, dynamic> json) {
    final item = (json['items'] as List).isNotEmpty ? json['items'][0] : {};
    final snippet = item['snippet'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final highThumb = thumbnails['high'] ?? {};
    final stats = item['statistics'] ?? {};
    final contentDetails = item['contentDetails'] ?? {};
    final relatedPlaylists = contentDetails['relatedPlaylists'] ?? {};

    return GetInfoChannelRes2(
      id: item['id'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'],
      customUrl: snippet['customUrl'],
      publishedAt: snippet['publishedAt'],
      avatarUrl: highThumb['url'],
      uploadsPlaylistId: relatedPlaylists['uploads'],
      viewCount: int.tryParse(stats['viewCount'] ?? '0') ?? 0,
      subscriberCount: int.tryParse(stats['subscriberCount'] ?? '0') ?? 0,
      videoCount: int.tryParse(stats['videoCount'] ?? '0') ?? 0,
    );
  }
}
