import 'package:flutter/material.dart';
import 'package:mehfilista/features/home/models/category_model.dart';
import 'package:mehfilista/features/home/models/home_recommendations_model.dart';
import 'package:mehfilista/features/home/models/location_model.dart';
import 'package:mehfilista/features/home/models/statistics_model.dart';
import 'package:mehfilista/features/home/services/home_service.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/utils/constants/app_config.dart';

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

  /// Demo data for offline mode
  void _loadDemoData() {
    _categories = [
      CategoryModel(name: 'Photography', count: 45, icon: 'camera'),
      CategoryModel(name: 'Catering', count: 32, icon: 'restaurant'),
      CategoryModel(name: 'Decoration', count: 28, icon: 'palette'),
      CategoryModel(name: 'Venues', count: 56, icon: 'location_city'),
      CategoryModel(name: 'Entertainment', count: 23, icon: 'music_note'),
      CategoryModel(name: 'Makeup', count: 41, icon: 'face'),
    ];

    _locations = [
      LocationModel(name: 'Lahore', vendorCount: 120),
      LocationModel(name: 'Karachi', vendorCount: 95),
      LocationModel(name: 'Islamabad', vendorCount: 78),
      LocationModel(name: 'Rawalpindi', vendorCount: 45),
      LocationModel(name: 'Faisalabad', vendorCount: 34),
    ];

    final demoVendors = [
      VendorModel(
        id: 'v1',
        userId: 'u1',
        businessName: 'Royal Photography',
        category: ['Photography'],
        services: 'Wedding photography, Pre-wedding shoots, Event coverage',
        location: 'Lahore',
        eventTypes: ['Wedding', 'Birthday', 'Corporate'],
        pricing: 'Starting from PKR 50,000',
        availability: 'Weekends available',
        averageRating: 4.8,
        totalReviews: 156,
        portfolioImages: [
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
          'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
        ],
        isApproved: true,
      ),
      VendorModel(
        id: 'v2',
        userId: 'u2',
        businessName: 'Elegant Catering',
        category: ['Catering'],
        services: 'Full catering service, Menu planning, Staff provided',
        location: 'Karachi',
        eventTypes: ['Wedding', 'Corporate', 'Anniversary'],
        pricing: 'PKR 800 per head',
        availability: 'All days',
        averageRating: 4.6,
        totalReviews: 89,
        portfolioImages: [
          'https://images.unsplash.com/photo-1555244162-803834f70033?w=400',
        ],
        isApproved: true,
      ),
      VendorModel(
        id: 'v3',
        userId: 'u3',
        businessName: 'Dream Decorators',
        category: ['Decoration'],
        services: 'Stage decoration, Floral arrangements, Lighting',
        location: 'Islamabad',
        eventTypes: ['Wedding', 'Engagement', 'Birthday'],
        pricing: 'Starting from PKR 100,000',
        availability: 'By appointment',
        averageRating: 4.9,
        totalReviews: 203,
        portfolioImages: [
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
        ],
        isApproved: true,
      ),
      VendorModel(
        id: 'v4',
        userId: 'u4',
        businessName: 'Grand Venues',
        category: ['Venues'],
        services: 'Indoor and outdoor venues, Full facility',
        location: 'Lahore',
        eventTypes: ['Wedding', 'Corporate', 'Birthday'],
        pricing: 'Starting from PKR 200,000',
        availability: 'Check availability',
        averageRating: 4.7,
        totalReviews: 312,
        portfolioImages: [
          'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
        ],
        isApproved: true,
      ),
    ];

    _recommendations = HomeRecommendationsModel(
      featuredVendors: demoVendors.take(3).toList(),
      recentVendors: demoVendors,
      popularCategories: _categories.take(4).toList(),
      statistics: StatisticsModel(
        totalVendors: 245,
        totalReviews: 1250,
        totalEventsBooked: 890,
      ),
    );
  }

  /// Load homepage recommendations
  Future<void> loadRecommendations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      _loadDemoData();
      _isLoading = false;
      notifyListeners();
      return;
    }

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
