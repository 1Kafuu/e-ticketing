import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/pref_keys.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(Map<String, dynamic> userMap);
  Future<Map<String, dynamic>?> getUser();
  Future<List<Map<String, dynamic>>?> getAllUsers();
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
  Future<List<Map<String, dynamic>>?> getAllUsers() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.userData);
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return (decoded as List).map((e) => e as Map<String, dynamic>).toList();
      }
      // Jika bukan list, return sebagai single item list
      return [decoded as Map<String, dynamic>];
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(PrefsKeys.userData);
  }
}