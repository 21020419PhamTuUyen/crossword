import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/data/models/game_state_model.dart';
import '../domain/data/models/user_model.dart';

class SPrefCache {
  // share preference key
  static const String KEY_TOKEN = "auth_token";
  static const String PREF_KEY_LANGUAGE = "pref_key_language";
  static const String PREF_KEY_USER_INFO = "pref_key_user_info";
  static const String PREF_KEY_IS_KEEP_LOGIN = "pref_key_is_keep_login";
}

class SharedPreferenceUtil {
  static Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.KEY_TOKEN, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefCache.KEY_TOKEN) ?? '';
  }

  static Future saveUserInfo(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefCache.PREF_KEY_USER_INFO, json.encode(user));
  }

  static Future<UserModel?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(SPrefCache.PREF_KEY_USER_INFO);
    if (data == null) {
      return null;
    }
    return UserModel.fromJson(json.decode(data));
  }

  static Future clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<GameStateModel?> getGameState(int stage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'stage_${stage}';
    String? data = prefs.getString(key);
    if (data == null) {
      return null;
    }
    return GameStateModel.fromJson(json.decode(data));
  }

  static Future<void> saveGameState(GameStateModel game) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'stage_${game.stage!.stage}';
    String gameStateJson = jsonEncode(game.toJson());
    await prefs.setString(key, gameStateJson);
  }
}
