import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_error_handler.dart';

class AuthServices {
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String phone,
    String role, {
    String? city,
    String? area,
  }) async {
    try {
      final body = <String, dynamic>{
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'role': role,
      };

      if (city != null && city.isNotEmpty) {
        body['city'] = city;
      }
      if (area != null && area.isNotEmpty) {
        body['area'] = area;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  Future<UserModel> getMe(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.me),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  Future<UserModel> updateProfile(
    String token,
    String name,
    String phone,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.updateProfile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'phone': phone}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }
}
