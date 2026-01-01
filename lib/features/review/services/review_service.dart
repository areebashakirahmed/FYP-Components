import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/review/models/review_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class ReviewService {
  /// Leave a review for a vendor (User only)
  Future<ApiResult<ReviewModel>> leaveReview({
    required String token,
    required String vendorId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.leaveReview),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vendor_id': vendorId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(ReviewModel.fromJson(data));
      } else {
        return ApiResult.failure('Failed to leave review: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get vendor reviews (Public)
  Future<ApiResult<List<ReviewModel>>> getVendorReviews(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.vendorReviews(vendorId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final reviews = data.map((e) => ReviewModel.fromJson(e)).toList();
        return ApiResult.success(reviews);
      } else {
        return ApiResult.failure('Failed to get reviews: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }
}
