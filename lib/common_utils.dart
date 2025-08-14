import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/res/get_info_channel_res.dart';

class CommonUtils {
  static final CommonUtils _instance = CommonUtils._internal();

  factory CommonUtils() {
    return _instance;
  }

  CommonUtils._internal();

  Future<void> savePref(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> _saveListPref(String key, List<String> list) async {
    final json = jsonEncode(list);
    await savePref(key, json);
  }

  Future<void> saveUniqueStringToList(String key, String value) async {
    List<String> currentList = await getListPref(key);
    currentList.remove(value);
    currentList.insert(0, value);

    if (currentList.length > 7) {
      currentList = currentList.sublist(0, 7);
    }

    await _saveListPref(key, currentList);
  }

  Future<List<String>> getListPref(String key) async {
    final jsonStr = await getPref(key);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearListPref(String key) async {
    await clearPref(key);
  }

  Future<void> saveUniqueChannelToList(String key, ChannelInfoItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final existingList = await getChannelList(key);

    existingList.removeWhere((e) => e.channelId == item.channelId);

    existingList.insert(0, item);

    List<Map<String, dynamic>> jsonList = existingList.map((e) => e.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    await prefs.setString(key, jsonString);
  }

  Future<ChannelInfoItem?> getChannelById(String key, String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      List<dynamic> jsonList = jsonDecode(jsonString);
      for (var jsonItem in jsonList) {
        final item = ChannelInfoItem.fromJson(jsonItem);
        if (item.channelId == channelId) {
          return item;
        }
      }
    } catch (e) {
      print(e);
    }

    return null;
  }


  Future<List<ChannelInfoItem>> getChannelList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((jsonItem) => ChannelInfoItem.fromJson(jsonItem))
          .toList();
    } catch (e) {
      return [];
    }
  }


}
