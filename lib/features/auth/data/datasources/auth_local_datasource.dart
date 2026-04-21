import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/pref_keys.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(Map<String, dynamic> userMap);
  Future<Map<String, dynamic>?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUser(Map<String, dynamic> userMap) async {
    await sharedPreferences.setString(PrefsKeys.userData, jsonEncode(userMap));
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.userData);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(PrefsKeys.userData);
  }
}