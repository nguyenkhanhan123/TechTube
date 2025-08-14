import 'package:flutter/material.dart';

class ItemPlaylist extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String itemCount;

  const ItemPlaylist({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 8, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.playlist_play, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                    '$channelName · Danh sách phát',
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
          // More icon
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
