import 'package:dio/dio.dart';
import 'package:my_youtube/model/req/get_cmt_video_req.dart';
import 'package:my_youtube/model/req/get_info_channel_req.dart';
import 'package:my_youtube/model/req/get_my_channel_req.dart';
import 'package:my_youtube/model/req/get_my_playlists_req.dart';
import 'package:my_youtube/model/req/search_video_req.dart';
import 'package:my_youtube/model/req/send_cmt_req.dart';
import 'package:my_youtube/model/res/get_info_channel_res.dart';
import 'package:my_youtube/model/res/get_view_video_res.dart';
import 'package:my_youtube/model/res/send_cmt_res.dart';
import '../model/req/get_info_video_req.dart';
import '../model/req/get_playlists_channel_req.dart';
import '../model/req/get_subscriptions_channel_req.dart';
import '../model/req/get_video_id_special_req.dart';
import '../model/req/get_video_req.dart';
import '../model/req/get_view_video_req.dart';
import '../model/res/get_cmt_video_res.dart';
import '../model/res/get_info_channel_res2.dart';
import '../model/res/get_info_video_res.dart';
import '../model/res/get_my_channel_res.dart';
import '../model/res/get_my_idchannel_res.dart';
import '../model/res/get_playlists_res.dart';
import '../model/res/get_subscriptions_res.dart';
import '../model/res/get_video_id_special_res.dart';
import '../model/res/get_video_res.dart';
import '../model/res/get_video_search_res.dart';

class YoutubeApi {
  final Dio _dio;

  YoutubeApi()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.googleapis.com/youtube/v3/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<GetVideoRes> getPopularVideos(GetVideoReq req) async {
    final response = await _dio.get(
      'videos',
      queryParameters: req.toMap(),
    );
    return GetVideoRes.fromJson(response.data);
  }

  Future<GetInfoChannelRes> getInfoChannel(GetInfoChannelReq req) async {
    final response = await _dio.get(
      'channels',
      queryParameters: req.toMap(),
    );
    return GetInfoChannelRes.fromJson(response.data);
  }

  Future<GetInfoChannelRes2> getInfoChannel2(GetInfoChannelReq req) async {
    final response = await _dio.get(
      'channels',
      queryParameters: req.toMap(),
    );
    return GetInfoChannelRes2.fromJson(response.data);
  }

  Future<GetMyChannelRes> getMyChannelWithToken(
      GetMyChannelReq req, String accessToken) async {
    final response = await _dio.get(
      'channels',
      queryParameters: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return GetMyChannelRes.fromJson(response.data);
  }

  Future<GetMyIdchannelRes> getMyIdChannelWithToken(
      GetMyChannelReq req, String accessToken) async {
    final response = await _dio.get(
      'channels',
      queryParameters: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return GetMyIdchannelRes.fromJson(response.data);
  }

  Future<GetSubscriptionsRes> getSubscribedChannelWithToken(
      GetSubscriptionsChannelReq req, String accessToken) async {
    final response = await _dio.get(
      'subscriptions',
      queryParameters: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return GetSubscriptionsRes.fromJson(response.data);
  }


  Future<GetPlaylistsRes> getMyPlaylistWithToken(
      GetMyPlaylistsReq req, String accessToken) async {
    final response = await _dio.get(
      'playlists',
      queryParameters: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return GetPlaylistsRes.fromJson(response.data);
  }

  Future<GetPlaylistsRes> getPlaylistWithId(
      GetPlaylistsChannelReq req) async {
    final response = await _dio.get(
      'playlists',
      queryParameters: req.toMap(),
    );
    return GetPlaylistsRes.fromJson(response.data);
  }

  Future<GetVideoIdSpecialRes> getVideoWithSpecialId(
      GetVideoIdSpecialReq req, String accessToken) async {
    final response = await _dio.get(
      'playlistItems',
      queryParameters: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return GetVideoIdSpecialRes.fromJson(response.data);
  }

  Future<SendCmtRes> postCmtWithToken(
      SendCmtReq req, String accessToken) async {
    final response = await _dio.post(
      'commentThreads?part=snippet',
      data: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return SendCmtRes.fromJson(response.data);
  }



  Future<GetVideoSearchRes> searchVideo(SearchVideoReq req) async {
    final response = await _dio.get(
      'search',
      queryParameters: req.toMap(),
    );
    return GetVideoSearchRes.fromJson(response.data);
  }

  Future<GetViewVideoRes> viewVideo(GetViewVideoReq req) async {
    final response = await _dio.get(
      'videos',
      queryParameters: req.toMap(),
    );
    return GetViewVideoRes.fromJson(response.data);
  }

  Future<GetInfoVideoRes> infoVideo(GetInfoVideoReq req) async {
    final response = await _dio.get(
      'videos',
      queryParameters: req.toMap(),
    );
    return GetInfoVideoRes.fromJson(response.data);
  }

  Future<GetCmtVideoRes> cmtVideo(GetCmtVideoReq req) async {
    final response = await _dio.get(
      'commentThreads',
      queryParameters: req.toMap(),
    );
    return GetCmtVideoRes.fromJson(response.data);
  }
}
