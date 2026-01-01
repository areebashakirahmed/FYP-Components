import 'package:flutter/material.dart';
import 'package:mehfilista/features/review/models/review_model.dart';
import 'package:mehfilista/features/review/services/review_service.dart';
import 'package:mehfilista/utils/constants/app_config.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  // State
  List<ReviewModel> _vendorReviews = [];
  bool _isLoading = false;
  String? _error;

  // Demo reviews
  static final List<ReviewModel> _demoReviews = [
    ReviewModel(
      id: 'rev1',
      userId: 'u1',
      vendorId: 'v1',
      rating: 5,
      comment:
          'Amazing photography! They captured every beautiful moment of our wedding perfectly. Highly recommended!',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      userName: 'Amina Khan',
    ),
    ReviewModel(
      id: 'rev2',
      userId: 'u2',
      vendorId: 'v1',
      rating: 4,
      comment:
          'Great work and professional service. The photos came out really well. Just a bit late on delivery.',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      userName: 'Hassan Ali',
    ),
    ReviewModel(
      id: 'rev3',
      userId: 'u3',
      vendorId: 'v1',
      rating: 5,
      comment:
          'Best decision we made for our wedding! The team was so friendly and creative.',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      userName: 'Zara Mahmood',
    ),
    ReviewModel(
      id: 'rev4',
      userId: 'u4',
      vendorId: 'v1',
      rating: 4,
      comment:
          'Very satisfied with their work. Professional team and quality output.',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      userName: 'Usman Raza',
    ),
    ReviewModel(
      id: 'rev5',
      userId: 'u5',
      vendorId: 'v1',
      rating: 5,
      comment:
          'Exceeded our expectations! Will definitely book again for future events.',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      userName: 'Ayesha Siddiqui',
    ),
  ];

  // Getters
  List<ReviewModel> get vendorReviews => _vendorReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Computed values
  double get averageRating {
    if (_vendorReviews.isEmpty) return 0.0;
    final total = _vendorReviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / _vendorReviews.length;
  }

  int get totalReviews => _vendorReviews.length;

  Map<int, int> get ratingDistribution {
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in _vendorReviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    return distribution;
  }

  /// Leave a review for a vendor (User only)
  Future<bool> leaveReview({
    required String token,
    required String vendorId,
    required int rating,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newReview = ReviewModel(
        id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'demo_user',
        vendorId: vendorId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        userName: 'Demo User',
      );
      _vendorReviews.insert(0, newReview);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    final result = await _reviewService.leaveReview(
      token: token,
      vendorId: vendorId,
      rating: rating,
      comment: comment,
    );

    bool success = false;
    result.when(
      success: (data) {
        _vendorReviews.insert(0, data); // Add to beginning
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

  /// Load reviews for a vendor (Public)
  Future<void> loadVendorReviews(String vendorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _vendorReviews = List.from(_demoReviews);
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _reviewService.getVendorReviews(vendorId);

    result.when(
      success: (data) {
        _vendorReviews = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Clear reviews
  void clearReviews() {
    _vendorReviews = [];
    _error = null;
    notifyListeners();
  }
}
