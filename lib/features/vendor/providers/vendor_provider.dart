import 'package:flutter/material.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/features/vendor/services/vendor_service.dart';
import 'package:mehfilista/utils/constants/app_config.dart';

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

  // Demo vendors
  static final List<VendorModel> _demoVendors = [
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
    VendorModel(
      id: 'v5',
      userId: 'u5',
      businessName: 'Melody Makers',
      category: ['Entertainment'],
      services: 'Live band, DJ services, Sound system rental',
      location: 'Lahore',
      eventTypes: ['Wedding', 'Birthday', 'Corporate'],
      pricing: 'Starting from PKR 75,000',
      availability: 'All days',
      averageRating: 4.5,
      totalReviews: 67,
      portfolioImages: [
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
      ],
      isApproved: true,
    ),
    VendorModel(
      id: 'v6',
      userId: 'u6',
      businessName: 'Glamour Studio',
      category: ['Makeup'],
      services: 'Bridal makeup, Party makeup, Hair styling',
      location: 'Karachi',
      eventTypes: ['Wedding', 'Engagement', 'Birthday'],
      pricing: 'Starting from PKR 25,000',
      availability: 'By appointment',
      averageRating: 4.9,
      totalReviews: 245,
      portfolioImages: [
        'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      ],
      isApproved: true,
    ),
  ];

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      _vendors = _demoVendors.where((vendor) {
        if (category != null && !vendor.category.contains(category)) {
          return false;
        }
        if (location != null && vendor.location != location) {
          return false;
        }
        if (eventType != null && !vendor.eventTypes.contains(eventType)) {
          return false;
        }
        if (minRating != null && vendor.averageRating < minRating) {
          return false;
        }
        return true;
      }).toList();
      _isLoading = false;
      notifyListeners();
      return;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _selectedVendor = _demoVendors.firstWhere(
        (v) => v.id == vendorId,
        orElse: () => _demoVendors.first,
      );
      _isLoading = false;
      notifyListeners();
      return;
    }

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
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      _myVendorProfile = VendorModel(
        id: 'demo_vendor',
        userId: 'demo_user',
        businessName: businessName,
        category: category,
        services: services,
        location: location,
        eventTypes: eventTypes,
        pricing: pricing,
        availability: availability,
        averageRating: 0.0,
        totalReviews: 0,
        portfolioImages: [],
        isApproved: false,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    final result = await _vendorService.createVendor(
      token: token,
      businessName: businessName,
      category: category,
      services: services,
      location: location,
      eventTypes: eventTypes,
      pricing: pricing,
      availability: availability,
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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _myVendorProfile = VendorModel(
        id: 'demo_vendor',
        userId: 'demo_user',
        businessName: 'My Demo Business',
        category: ['Photography', 'Decoration'],
        services: 'Wedding photography, Event decoration, Lighting setup',
        location: 'Lahore',
        eventTypes: ['Wedding', 'Birthday', 'Corporate'],
        pricing: 'Starting from PKR 50,000',
        availability: 'All days except Monday',
        averageRating: 4.7,
        totalReviews: 45,
        portfolioImages: [
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
          'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
        ],
        isApproved: true,
      );
      _isLoading = false;
      notifyListeners();
      return;
    }

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
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_myVendorProfile != null) {
        _myVendorProfile = VendorModel(
          id: _myVendorProfile!.id,
          userId: _myVendorProfile!.userId,
          businessName: businessName ?? _myVendorProfile!.businessName,
          category: category ?? _myVendorProfile!.category,
          services: services ?? _myVendorProfile!.services,
          location: location ?? _myVendorProfile!.location,
          eventTypes: eventTypes ?? _myVendorProfile!.eventTypes,
          pricing: pricing ?? _myVendorProfile!.pricing,
          availability: availability ?? _myVendorProfile!.availability,
          averageRating: _myVendorProfile!.averageRating,
          totalReviews: _myVendorProfile!.totalReviews,
          portfolioImages: _myVendorProfile!.portfolioImages,
          isApproved: _myVendorProfile!.isApproved,
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

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

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_myVendorProfile != null) {
        final updatedImages = [..._myVendorProfile!.portfolioImages, imagePath];
        _myVendorProfile = VendorModel(
          id: _myVendorProfile!.id,
          userId: _myVendorProfile!.userId,
          businessName: _myVendorProfile!.businessName,
          category: _myVendorProfile!.category,
          services: _myVendorProfile!.services,
          location: _myVendorProfile!.location,
          eventTypes: _myVendorProfile!.eventTypes,
          pricing: _myVendorProfile!.pricing,
          availability: _myVendorProfile!.availability,
          averageRating: _myVendorProfile!.averageRating,
          totalReviews: _myVendorProfile!.totalReviews,
          portfolioImages: updatedImages,
          isApproved: _myVendorProfile!.isApproved,
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

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
