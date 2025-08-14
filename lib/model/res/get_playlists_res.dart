class GetPlaylistsRes {
  final List<PlaylistsItem> items;

  GetPlaylistsRes({required this.items});

  factory GetPlaylistsRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => PlaylistsItem.fromJson(item)).toList();
    return GetPlaylistsRes(items: items);
  }
}

class PlaylistsItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String itemCount;
  final String channelTitle;

  PlaylistsItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.itemCount,
    required this.channelTitle,
  });

  factory PlaylistsItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final contentDetails = json['contentDetails'] ?? {};

    return PlaylistsItem(
      id: json['id'],
      title: snippet['title'] ?? '',
      thumbnailUrl: snippet['thumbnails']['medium']['url'] ?? '',
      itemCount: contentDetails['itemCount']?.toString() ?? '0',
      channelTitle: snippet['channelTitle'] ?? '',
    );
  }
}
