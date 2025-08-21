import 'package:flutter/material.dart';
import 'package:my_youtube/view/item_recent_search.dart';
import 'package:my_youtube/view/item_suggestion_search.dart';
import 'package:provider/provider.dart';

import '../viewmodel/search_viewmodel.dart';
import 'item_video.dart';

class SearchAct extends StatelessWidget {
  final String? initialQuery;

  const SearchAct({Key? key, this.initialQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewmodel(initialQuery: initialQuery),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Consumer<SearchViewmodel>(
            builder: (context, vm, child) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: vm.controller,
                      focusNode: vm.focusNode,
                      onChanged: vm.updateQuery,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Tìm trên TechTube...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (vm.controller.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Vui lòng nhập từ khóa tìm kiếm!")),
                              );
                            } else {
                              vm.search();
                            }
                          },
                          icon: Icon(Icons.search, size: 28, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Consumer<SearchViewmodel>(
          builder: (context, vm, child) {
            switch (vm.state) {
              case SearchState.suggestion:
                if (vm.query.isEmpty) {
                  return ListView.builder(
                    itemCount: vm.suggestions.length,
                    itemBuilder: (context, index) {
                      final text = vm.suggestions[index];
                      return ItemRecentSearch(
                        text: text,
                        onTap: () => vm.selectSuggestion(text),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: vm.suggestions.length,
                    itemBuilder: (context, index) {
                      final text = vm.suggestions[index];
                      return ItemSuggestionSearch(
                        text: text,
                        onTap: () => vm.selectSuggestion(text),
                      );
                    },
                  );
                }
              case SearchState.loading:
                return Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                );
              case SearchState.result:
                return ListView.builder(
                  itemCount: vm.videos.length,
                  itemBuilder: (context, index) {
                    final video = vm.videos[index];
                    return ItemVideo(
                      id: video.id,
                      title: video.title,
                      thumbnailUrl: video.thumbnailUrl,
                      publishedAt: video.publishedAt,
                      viewCount: video.viewCount,
                      channelUrl: video.channelUrl,
                      channelName: video.channelName,
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
