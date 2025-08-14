class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelUrl;
  final String channelName;
  final String publishedAt;
  final String viewCount;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.viewCount,
    required this.channelUrl,
    required this.channelName,
  });
}