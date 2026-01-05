import 'package:flutter/material.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/services/vendor_service.dart';

class VendorProvider extends ChangeNotifier {
  final VendorService _vendorService = VendorService();

  // State
  List<VendorModel> _vendors = [];
  VendorModel? _selectedVendor;
  VendorModel? _myVendorProfile;
  bool _isLoading = false;
  String? _error;

  // Search filters
  String? _categoryFilter;
  String? _locationFilter;
  String? _eventTypeFilter;
  double? _minRatingFilter;

  // Getters
  List<VendorModel> get vendors => _vendors;
  VendorModel? get selectedVendor => _selectedVendor;
  VendorModel? get myVendorProfile => _myVendorProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasVendorProfile => _myVendorProfile != null;

  // Filter getters
  String? get categoryFilter => _categoryFilter;
  String? get locationFilter => _locationFilter;
  String? get eventTypeFilter => _eventTypeFilter;
  double? get minRatingFilter => _minRatingFilter;

  /// Search vendors with filters
  Future<void> searchVendors({
    String? category,
    String? location,
    String? eventType,
    double? minRating,
    bool? approvedOnly,
  }) async {
    _isLoading = true;
    _error = null;

    // Update filters
    _categoryFilter = category;
    _locationFilter = location;
    _eventTypeFilter = eventType;
    _minRatingFilter = minRating;

    notifyListeners();

    final result = await _vendorService.searchVendors(
      category: category,
      location: location,
      eventType: eventType,
      minRating: minRating,
      approvedOnly: approvedOnly,
    );

    result.when(
      success: (data) {
        _vendors = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Get vendor details by ID
  Future<void> getVendorDetails(String vendorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _vendorService.getVendorDetails(vendorId);

    result.when(
      success: (data) {
        _selectedVendor = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Create vendor profile (Vendor only)
  Future<bool> createVendorProfile({
    required String token,
    required String businessName,
    required List<String> category,
    required String services,
    required String location,
    required List<String> eventTypes,
    required String pricing,
    required String availability,
    String? contactPhone,
    String? contactEmail,
    String? description,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _vendorService.createVendor(
      token: token,
      businessName: businessName,
      category: category,
      services: services,
      location: location,
      eventTypes: eventTypes,
      pricing: pricing,
      availability: availability,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      description: description,
    );

    bool success = false;
    result.when(
      success: (data) {
        _myVendorProfile = data;
        _error = null;
        success = true;
      },
      failure: (error) {
        _error = error;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Get my vendor profile (Vendor only)
  Future<void> loadMyVendorProfile(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _vendorService.getMyVendorProfile(token);

    result.when(
      success: (data) {
        _myVendorProfile = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Update vendor profile (Vendor only)
  Future<bool> updateVendorProfile({
    required String token,
    required String vendorId,
    String? businessName,
    List<String>? category,
    String? services,
    String? location,
    List<String>? eventTypes,
    String? pricing,
    String? availability,
    String? contactPhone,
    String? contactEmail,
    String? description,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _vendorService.updateVendor(
      token: token,
      vendorId: vendorId,
      businessName: businessName,
      category: category,
      services: services,
      location: location,
      eventTypes: eventTypes,
      pricing: pricing,
      availability: availability,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      description: description,
    );

    bool success = false;
    result.when(
      success: (data) {
        _myVendorProfile = data;
        _error = null;
        success = true;
      },
      failure: (error) {
        _error = error;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Upload portfolio image (Vendor only)
  Future<bool> uploadPortfolioImage({
    required String token,
    required String vendorId,
    required String imagePath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _vendorService.uploadPortfolioImage(
      token: token,
      vendorId: vendorId,
      imagePath: imagePath,
    );

    bool success = false;
    result.when(
      success: (data) {
        _myVendorProfile = data;
        _error = null;
        success = true;
      },
      failure: (error) {
        _error = error;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Clear filters and search results
  void clearFilters() {
    _categoryFilter = null;
    _locationFilter = null;
    _eventTypeFilter = null;
    _minRatingFilter = null;
    _vendors = [];
    _error = null;
    notifyListeners();
  }

  /// Clear selected vendor
  void clearSelectedVendor() {
    _selectedVendor = null;
    notifyListeners();
  }

  /// Clear all data
  void clearAllData() {
    _vendors = [];
    _selectedVendor = null;
    _myVendorProfile = null;
    _error = null;
    _categoryFilter = null;
    _locationFilter = null;
    _eventTypeFilter = null;
    _minRatingFilter = null;
    notifyListeners();
  }
}
