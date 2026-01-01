import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  // Check initial connection on startup
  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  // Update status when connection changes
  void _updateStatus(List<ConnectivityResult> results) {
    // When there is NO 'none' in results => online
    _isOnline = !results.contains(ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
