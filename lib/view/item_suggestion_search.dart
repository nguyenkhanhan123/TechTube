import 'package:flutter/material.dart';

class ItemSuggestionSearch extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ItemSuggestionSearch({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(.0,2.0,.0,2.0),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(9.0,9.0,11.0,9.0),
            child: Icon(Icons.search, size: 24, color: Colors.black),
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(.0),
            child: IconButton(
              onPressed: onTap,
              icon: Icon(Icons.north_west, size: 24, color: Colors.black),
            ),
          ),
        ],
      ));
  }
}
