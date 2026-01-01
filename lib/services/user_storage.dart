import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mehfilista/features/auth/model/user_model.dart';

class UserStorage {
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'user_details';
  static const _tokenKey = 'auth_token';

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _tokenKey);
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }
}
