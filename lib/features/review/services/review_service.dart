import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/review/models/review_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class ReviewService {
  /// Helper to extract error message from API response
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);

      // Handle validation errors (422)
      if (response.statusCode == 422 && body['detail'] is List) {
        final errors = body['detail'] as List;
        return errors.map((e) => '${e['loc']?.last ?? ''}: ${e['msg']}').join('\n');
      }

      // Handle standard errors
      if (body['detail'] != null) {
        return body['detail'].toString();
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Something went wrong';
    }
  }

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
      } else if (response.statusCode == 403) {
        return ApiResult.failure('Only user accounts can leave reviews');
      } else if (response.statusCode == 404) {
        return ApiResult.failure('Vendor not found');
      } else if (response.statusCode == 400) {
        final body = jsonDecode(response.body);
        if (body['detail']?.toString().contains('already') == true) {
          return ApiResult.failure('You have already reviewed this vendor');
        }
        return ApiResult.failure(_getErrorMessage(response));
      } else {
        return ApiResult.failure(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure('Network error. Please check your connection.');
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
