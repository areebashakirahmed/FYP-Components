import 'package:flutter/material.dart';
import 'package:mehfilista/features/review/models/review_model.dart';
import 'package:mehfilista/features/review/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  // State
  List<ReviewModel> _vendorReviews = [];
  bool _isLoading = false;
  String? _error;

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
