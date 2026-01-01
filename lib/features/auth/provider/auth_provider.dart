import 'package:flutter/material.dart';
import 'package:mehfilista/features/auth/auth_services.dart';
import 'package:mehfilista/features/auth/model/user_model.dart';
import 'package:mehfilista/services/user_storage.dart';
import 'package:mehfilista/utils/constants/app_config.dart';

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

  /// Demo mode login - creates a fake user for testing UI
  void _setDemoUser(String role) {
    _user = UserModel(
      id: 'demo_${role}_001',
      email: role == 'vendor' ? 'vendor@mehfilista.com' : 'user@mehfilista.com',
      name: role == 'vendor' ? 'Demo Vendor' : 'Demo User',
      phone: '+92 300 1234567',
      role: role,
    );
    _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    // In demo mode, check if we have a saved demo user
    if (kDemoMode) {
      _token = await _userStorage.getToken();
      if (_token != null && _token!.startsWith('demo_token_')) {
        _user = await _userStorage.getUser();
      }
      _isLoading = false;
      notifyListeners();
      return;
    }

    _token = await _userStorage.getToken();
    if (_token != null) {
      try {
        _user = await _userStorage.getUser();
        if (_user == null) {
          _user = await _authServices.getMe(_token!);
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

    // Demo mode - simulate successful registration
    if (kDemoMode) {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network
      _user = UserModel(
        id: 'demo_${role}_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        role: role,
      );
      _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
      await _userStorage.saveToken(_token!);
      await _userStorage.saveUser(_user!);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    try {
      final data = await _authServices.register(
        email,
        password,
        name,
        phone,
        role,
      );
      _token = data['token'];
      _user = UserModel.fromJson(data['user']);
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

    // Demo mode - simulate successful login
    if (kDemoMode) {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network
      // Determine role based on email
      final role = email.toLowerCase().contains('vendor') ? 'vendor' : 'user';
      _setDemoUser(role);
      await _userStorage.saveToken(_token!);
      await _userStorage.saveUser(_user!);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    try {
      final data = await _authServices.login(email, password);
      _token = data['token'];
      _user = UserModel.fromJson(data['user']);
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
