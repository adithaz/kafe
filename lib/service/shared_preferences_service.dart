import 'dart:convert';

import 'package:kafe/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String userKey = 'current_user';

  Future<void> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(userKey, userJson);
  }

  Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);
    if (userJson == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromJson(userMap);
  }

  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}