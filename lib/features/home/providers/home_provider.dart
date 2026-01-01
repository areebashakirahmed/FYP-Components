import 'package:flutter/material.dart';
import 'package:mehfilista/features/home/models/category_model.dart';
import 'package:mehfilista/features/home/models/home_recommendations_model.dart';
import 'package:mehfilista/features/home/models/location_model.dart';
import 'package:mehfilista/features/home/services/home_service.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  // State
  HomeRecommendationsModel? _recommendations;
  List<CategoryModel> _categories = [];
  List<LocationModel> _locations = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  HomeRecommendationsModel? get recommendations => _recommendations;
  List<VendorModel> get featuredVendors =>
      _recommendations?.featuredVendors ?? [];
  List<VendorModel> get recentVendors => _recommendations?.recentVendors ?? [];
  List<CategoryModel> get popularCategories =>
      _recommendations?.popularCategories ?? [];
  List<CategoryModel> get categories => _categories;
  List<LocationModel> get locations => _locations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Statistics getters
  int get totalVendors => _recommendations?.statistics.totalVendors ?? 0;
  int get totalReviews => _recommendations?.statistics.totalReviews ?? 0;
  int get totalEventsBooked =>
      _recommendations?.statistics.totalEventsBooked ?? 0;

  /// Load homepage recommendations
  Future<void> loadRecommendations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _homeService.getRecommendations();

    result.when(
      success: (data) {
        _recommendations = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _homeService.getCategories();

    result.when(
      success: (data) {
        _categories = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Load all locations
  Future<void> loadLocations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _homeService.getLocations();

    result.when(
      success: (data) {
        _locations = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Load all home data at once
  Future<void> loadAllHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Load all data in parallel
    await Future.wait([
      loadRecommendations(),
      loadCategories(),
      loadLocations(),
    ]);
  }

  /// Clear all data
  void clearData() {
    _recommendations = null;
    _categories = [];
    _locations = [];
    _error = null;
    notifyListeners();
  }

  /// Check if API is available
  Future<bool> checkApiHealth() async {
    return await _homeService.healthCheck();
  }
}
