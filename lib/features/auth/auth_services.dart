import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';

class AuthServices {
  /// Helper to extract error message from API response
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);

      // Handle validation errors (422)
      if (response.statusCode == 422 && body['detail'] is List) {
        final errors = body['detail'] as List;
        return errors.map((e) => '${e['loc']?.last ?? ''}: ${e['msg']}').join('\n');
      }

      // Handle standard errors
      if (body['detail'] != null) {
        return body['detail'].toString();
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Something went wrong';
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String phone,
    String role,
  ) async {
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

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data; // {access_token, token_type, user}
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      if (body['detail'] == 'Email already registered') {
        throw Exception('This email is already registered. Please login or use a different email.');
      }
      throw Exception(body['detail'] ?? 'Registration failed');
    } else {
      throw Exception(_getErrorMessage(response));
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
      return data; // {access_token, token_type, user}
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password. Please check your credentials.');
    } else {
      throw Exception(_getErrorMessage(response));
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
    } else if (response.statusCode == 401) {
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception(_getErrorMessage(response));
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

    if (response.statusCode == 200) {
      return; // Success
    } else if (response.statusCode == 404) {
      throw Exception('No account found with this email address.');
    } else {
      throw Exception(_getErrorMessage(response));
    }
  }
}
