import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class VendorService {
  /// Search vendors with filters
  Future<ApiResult<List<VendorModel>>> searchVendors({
    String? category,
    String? location,
    String? eventType,
    double? minRating,
    bool? approvedOnly,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;
      if (eventType != null) queryParams['event_type'] = eventType;
      if (minRating != null) queryParams['min_rating'] = minRating.toString();
      if (approvedOnly != null)
        queryParams['approved_only'] = approvedOnly.toString();

      final uri = Uri.parse(
        ApiConstants.vendorsSearch,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final vendors = data.map((e) => VendorModel.fromJson(e)).toList();
        return ApiResult.success(vendors);
      } else {
        return ApiResult.failure('Failed to search vendors: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get vendor details by ID
  Future<ApiResult<VendorModel>> getVendorDetails(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.vendorDetails(vendorId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure(
          'Failed to get vendor details: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Create vendor profile (Vendor only)
  Future<ApiResult<VendorModel>> createVendor({
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
    try {
      final body = <String, dynamic>{
        'business_name': businessName,
        'category': category,
        'services': services,
        'location': location,
        'event_types': eventTypes,
        'pricing': pricing,
        'availability': availability,
      };
      if (contactPhone != null && contactPhone.isNotEmpty) {
        body['contact_phone'] = contactPhone;
      }
      if (contactEmail != null && contactEmail.isNotEmpty) {
        body['contact_email'] = contactEmail;
      }
      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.createVendor),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure('Failed to create vendor: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get my vendor profile (Vendor only)
  Future<ApiResult<VendorModel>> getMyVendorProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.myVendor),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure(
          'Failed to get vendor profile: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Update vendor profile (Vendor only)
  Future<ApiResult<VendorModel>> updateVendor({
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
    try {
      final body = <String, dynamic>{};
      if (businessName != null) body['business_name'] = businessName;
      if (category != null) body['category'] = category;
      if (services != null) body['services'] = services;
      if (location != null) body['location'] = location;
      if (eventTypes != null) body['event_types'] = eventTypes;
      if (pricing != null) body['pricing'] = pricing;
      if (availability != null) body['availability'] = availability;
      if (contactPhone != null) body['contact_phone'] = contactPhone;
      if (contactEmail != null) body['contact_email'] = contactEmail;
      if (description != null) body['description'] = description;

      final response = await http.put(
        Uri.parse(ApiConstants.updateVendor(vendorId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure('Failed to update vendor: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Upload portfolio image (Vendor only)
  Future<ApiResult<VendorModel>> uploadPortfolioImage({
    required String token,
    required String vendorId,
    required String imagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadPortfolio(vendorId)),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }
}
