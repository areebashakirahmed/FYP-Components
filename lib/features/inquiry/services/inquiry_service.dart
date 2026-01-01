import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/inquiry/models/inquiry_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class InquiryService {
  /// Send inquiry to a vendor (User only)
  Future<ApiResult<InquiryModel>> sendInquiry({
    required String token,
    required String vendorId,
    required String eventType,
    required String preferredDate,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.sendInquiry),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vendor_id': vendorId,
          'event_type': eventType,
          'preferred_date': preferredDate,
          'message': message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(InquiryModel.fromJson(data));
      } else {
        return ApiResult.failure('Failed to send inquiry: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get my inquiries (User only)
  Future<ApiResult<List<InquiryModel>>> getMyInquiries(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.myInquiries),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final inquiries = data.map((e) => InquiryModel.fromJson(e)).toList();
        return ApiResult.success(inquiries);
      } else {
        return ApiResult.failure('Failed to get inquiries: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get vendor inquiries (Vendor only)
  Future<ApiResult<List<InquiryModel>>> getVendorInquiries(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.vendorInquiries),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final inquiries = data.map((e) => InquiryModel.fromJson(e)).toList();
        return ApiResult.success(inquiries);
      } else {
        return ApiResult.failure(
          'Failed to get vendor inquiries: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get inquiry details
  Future<ApiResult<InquiryModel>> getInquiryDetails({
    required String token,
    required String inquiryId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.inquiryDetails(inquiryId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(InquiryModel.fromJson(data));
      } else {
        return ApiResult.failure(
          'Failed to get inquiry details: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Respond to inquiry (Vendor only)
  Future<ApiResult<InquiryModel>> respondToInquiry({
    required String token,
    required String inquiryId,
    required String status, // 'accepted' or 'declined'
    required String vendorResponse,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.respondInquiry(inquiryId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status, 'vendor_response': vendorResponse}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(InquiryModel.fromJson(data));
      } else {
        return ApiResult.failure(
          'Failed to respond to inquiry: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }
}
