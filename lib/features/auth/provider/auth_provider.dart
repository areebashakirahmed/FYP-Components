import 'package:flutter/material.dart';
import 'package:mehfilista/features/auth/auth_services.dart';
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/services/user_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  final UserStorage _userStorage = UserStorage();

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isVendor => _user?.role == 'vendor';
  bool get isUser => _user?.role == 'user';

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _token = await _userStorage.getToken();

    // Clear any old demo tokens from previous sessions
    if (_token != null && _token!.startsWith('demo_token_')) {
      await logout();
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (_token != null) {
      try {
        // Always validate token with API
        _user = await _authServices.getMe(_token!);
        if (_user != null) {
          await _userStorage.saveUser(_user!);
        }
      } catch (e) {
        // Token invalid, logout
        await logout();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register(
    String email,
    String password,
    String name,
    String phone,
    String role,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authServices.register(
        email,
        password,
        name,
        phone,
        role,
      );

      // Validate response data (API returns access_token, not token)
      if (data['access_token'] == null || data['user'] == null) {
        throw Exception('Invalid response from server');
      }

      _token = data['access_token'] as String;
      _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

      await _userStorage.saveToken(_token!);
      await _userStorage.saveUser(_user!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authServices.login(email, password);

      // Validate response data (API returns access_token, not token)
      if (data['access_token'] == null || data['user'] == null) {
        throw Exception('Invalid response from server');
      }

      _token = data['access_token'] as String;
      _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

      await _userStorage.saveToken(_token!);
      await _userStorage.saveUser(_user!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _userStorage.deleteUser();
    _user = null;
    _token = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String phone) async {
    if (_token == null) {
      _error = 'Not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _authServices.updateProfile(_token!, name, phone);
      _user = updatedUser;
      await _userStorage.saveUser(_user!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authServices.resetPassword(email, newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
