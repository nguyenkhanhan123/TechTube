class GetViewVideoRes {
  final List<ViewVideoItem> items;

  GetViewVideoRes({required this.items});

  factory GetViewVideoRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => ViewVideoItem.fromJson(item)).toList();
    return GetViewVideoRes(items: items);
  }
}

class ViewVideoItem {
  final String id;
  final String viewCount;

  ViewVideoItem({
    required this.id,
    required this.viewCount,
  });

  factory ViewVideoItem.fromJson(Map<String, dynamic> json) {
    final statistics = json['statistics'] ?? {};

    return ViewVideoItem(
      id: json['id'],
      viewCount: statistics['viewCount'] ?? '0',
    );
  }
}

