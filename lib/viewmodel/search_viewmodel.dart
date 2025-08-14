import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_suggestion_req.dart';
import 'package:my_youtube/model/req/get_view_video_req.dart';
import 'package:my_youtube/model/req/search_video_req.dart';

import '../api/suggestion_api.dart';
import '../api/youtube_api.dart';
import '../common_utils.dart';
import '../model/req/get_info_channel_req.dart';
import '../model/video.dart';
import '../view/home_frag.dart';

enum SearchState { suggestion, loading, result }

class SearchViewmodel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Timer? _debounce;

  List<String> _suggestions = [];

  List<Video> _videos = [];

  List<String> get suggestions => _suggestions;

  set suggestions(List<String> value) {
    _suggestions = value;
  }

  List<Video> get videos => _videos;

  set videos(List<Video> value) {
    _videos = value;
  }

  SearchState _state = SearchState.suggestion;
  SearchState get state => _state;

  String _query = '';
  String get query => _query;

  SearchViewModel() {
    focusNode.addListener(_onFocusChange);
    updateQuery(' ');
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      _state = SearchState.suggestion;
    } else {
      if (_videos.isNotEmpty && controller.text.isNotEmpty) {
        _state = SearchState.result;
      }
      else{
        _state = SearchState.suggestion;
      }
    }
    notifyListeners();
  }

  Future<void> updateQuery(String value) async {
    _query = value.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (_query.isEmpty) {
        List<String> searches = await CommonUtils().getListPref('recent_keywords');
        if(searches.isEmpty){
          _suggestions = [
            'Flutter căn bản',
            'MVVM trong Flutter',
            'State Management',
            'Build UI với Column',
            'Provider vs Riverpod',
          ];
        }
        else{
          _suggestions=searches;
        }
        _state = SearchState.suggestion;
        notifyListeners();
      } else {
        final _api = SuggestionApi();
        try {
          final results = await _api.getSuggestion(
            GetSuggestionReq(client: 'firefox', ds: 'yt', q: _query)
          );
          _suggestions = results;
          _state = SearchState.suggestion;
        } catch (e) {
          _suggestions = ["Lỗi khi tìm kiếm"];
          _state = SearchState.suggestion;
        }

        notifyListeners();
      }
    });
  }


  Future<void> search() async {
    if (_query.isEmpty) return;

    CommonUtils().saveUniqueStringToList('recent_keywords', _query);

    _state = SearchState.loading;
    notifyListeners();

    final api = YoutubeApi();

    final result = await api.searchVideo(
      SearchVideoReq(
        part: 'snippet',
        q: _query,
        type: 'video',
        maxResults: 30,
        regionCode: 'VN',
        videoCategoryId: '28',
        key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
      ),
    );

    final fetchedVideos = result.items;

    final videoIds = fetchedVideos.map((v) => v.id).toList();

    print(videoIds);

    final statsRes = await api.viewVideo(
      GetViewVideoReq(part: 'statistics', id: videoIds.join(','), key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw')
    );

    final Map<String, String> videoStatsMap = {
      for (var item in statsRes.items)
        item.id: item.viewCount ?? '0',
    };

    final channelIds = fetchedVideos.map((v) => v.channelId).toSet().toList();

    final utils = CommonUtils();
    final String storageKey = 'cached_channels';

    final Map<String, ChannelInfo> infoMap = {};

    for (final id in channelIds) {

      final localChannel = await utils.getChannelById(storageKey, id);


      if (localChannel != null) {
        infoMap[id] = ChannelInfo(
          avatarUrl: localChannel.thumbnailUrl ?? '',
          title: localChannel.title ?? '',
        );
        continue;
      }

      try {
        final channelRes = await api.getInfoChannel(
          GetInfoChannelReq(
            part: 'snippet,statistics',
            id: id,
            key: 'AIzaSyCVqRLteCYu79ff-lhVejJnJO9wRmScWmw',
          ),
        );

        if (channelRes.items.isNotEmpty) {
          final item = channelRes.items.first;

          await utils.saveUniqueChannelToList(storageKey, item);

          infoMap[id] = ChannelInfo(
            avatarUrl: item.thumbnailUrl ?? '',
            title: item.title ?? '',
          );
        }
      } catch (e) {
        infoMap[id] = ChannelInfo(avatarUrl: '', title: '');
      }
    }

    _videos = fetchedVideos.map((item) {
      return Video(
        id: item.id ?? '',
        title: item.title ?? '',
        thumbnailUrl: item.thumbnailUrl ?? '',
        publishedAt: item.publishedAt ?? '',
        viewCount: videoStatsMap[item.id] ?? '0',
        channelUrl:  infoMap[item.channelId]?.avatarUrl ?? '',
        channelName: infoMap[item.channelId]?.title ?? '',
      );
    }).toList();

    _state = SearchState.result;
    notifyListeners();
  }

  void selectSuggestion(String suggestion) {
    controller.text = suggestion;
    _query = suggestion;
    search();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
