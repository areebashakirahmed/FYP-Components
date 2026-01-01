import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';

class AuthServices {
  Future<Map<String, dynamic>> register(String email, String password, String name, String phone, String role) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'role': role,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // {token, user}
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<UserModel> getMe(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.me),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse(ApiConstants.resetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'new_password': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Reset password failed: ${response.body}');
    }
  }
}
