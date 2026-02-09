import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/vendor/models/vendor_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';
import 'package:mehfilista/utils/api_error_handler.dart';

class VendorService {
  /// Search vendors with filters
  /// Supports: category, city, area, event_type, min_rating, approved_only
  Future<ApiResult<List<VendorModel>>> searchVendors({
    String? category,
    String? city,
    String? area,
    String? location,
    String? eventType,
    double? minRating,
    bool? approvedOnly,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (city != null) queryParams['city'] = city;
      if (area != null) queryParams['area'] = area;
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
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
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
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Create vendor profile (Vendor only)
  /// Matches backend VendorCreate schema exactly
  Future<ApiResult<VendorModel>> createVendor({
    required String token,
    required String businessName,
    required List<String> category,
    required String services,
    required String city,
    required String area,
    required List<String> eventTypes,
    required String cnicNumber,
    required String cnicFrontImage,
    required String cnicBackImage,
    required String whatsappNumber,
    Map<String, dynamic>? basicPackage,
    Map<String, dynamic>? premiumPackage,
    Map<String, dynamic>? luxuryPackage,
    String availability = 'active',
    // Legacy optional fields (not in backend schema but kept for compat)
    String? contactPhone,
    String? contactEmail,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{
        'business_name': businessName,
        'category': category,
        'services': services,
        'city': city,
        'area': area,
        'event_types': eventTypes,
        'cnic_number': cnicNumber,
        'cnic_front_image': cnicFrontImage,
        'cnic_back_image': cnicBackImage,
        'whatsapp_number': whatsappNumber,
        'availability': availability,
      };
      if (basicPackage != null) {
        body['basic_package'] = basicPackage;
      }
      if (premiumPackage != null) {
        body['premium_package'] = premiumPackage;
      }
      if (luxuryPackage != null) {
        body['luxury_package'] = luxuryPackage;
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
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
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
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Update vendor profile (Vendor only)
  /// Matches backend VendorUpdate schema (all optional). Supports profile_picture and portfolio_images.
  Future<ApiResult<VendorModel>> updateVendor({
    required String token,
    required String vendorId,
    String? businessName,
    List<String>? category,
    String? services,
    String? city,
    String? area,
    List<String>? eventTypes,
    String? whatsappNumber,
    Map<String, dynamic>? basicPackage,
    Map<String, dynamic>? premiumPackage,
    Map<String, dynamic>? luxuryPackage,
    String? availability,
    String? profilePicture,
    List<String>? portfolioImages,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (businessName != null) body['business_name'] = businessName;
      if (category != null) body['category'] = category;
      if (services != null) body['services'] = services;
      if (city != null) body['city'] = city;
      if (area != null) body['area'] = area;
      if (eventTypes != null) body['event_types'] = eventTypes;
      if (whatsappNumber != null) body['whatsapp_number'] = whatsappNumber;
      if (basicPackage != null) body['basic_package'] = basicPackage;
      if (premiumPackage != null) body['premium_package'] = premiumPackage;
      if (luxuryPackage != null) body['luxury_package'] = luxuryPackage;
      if (availability != null) body['availability'] = availability;
      if (profilePicture != null) body['profile_picture'] = profilePicture;
      if (portfolioImages != null) body['portfolio_images'] = portfolioImages;

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
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
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

      // Backend requires field name 'file' (not 'image')
      final file = await http.MultipartFile.fromPath('file', imagePath);
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else {
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Upload a single image using the new /upload/image endpoint
  /// Returns the file_path from the server
  Future<ApiResult<String>> uploadImage({
    required String token,
    required String filePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadImage),
      );
      request.headers['Authorization'] = 'Bearer $token';

      final file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final filePath = data['file_path'] ?? data['url'] ?? '';
        return ApiResult.success(filePath);
      } else {
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Upload multiple images using the new /upload/images endpoint
  /// Returns list of file_path from the server
  Future<ApiResult<List<String>>> uploadMultipleImages({
    required String token,
    required List<String> filePaths,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadImages),
      );
      request.headers['Authorization'] = 'Bearer $token';

      for (final path in filePaths) {
        final file = await http.MultipartFile.fromPath('files', path);
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final uploaded = data['uploaded'] as List<dynamic>;
        final paths = uploaded
            .map((file) => file['file_path'] as String)
            .toList();
        return ApiResult.success(paths);
      } else {
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Delete an uploaded file
  Future<ApiResult<bool>> deleteUploadedFile({
    required String token,
    required String filename,
  }) async {
    try {
      // Extract just filename from path if needed
      final filenameOnly = filename.split('/').last;

      final response = await http.delete(
        Uri.parse(ApiConstants.deleteUploadedFile(filenameOnly)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResult.success(true);
      } else {
        return ApiResult.failure(ApiErrorHandler.getErrorMessage(response));
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }

  /// Legacy upload method - uses new uploadImage internally
  @Deprecated('Use uploadImage instead')
  Future<ApiResult<String>> uploadFile({
    required String token,
    required String filePath,
  }) async {
    return uploadImage(token: token, filePath: filePath);
  }

  /// Upload CNIC images for verification (Vendor only)
  /// Uses the new /upload/image endpoint
  Future<ApiResult<Map<String, String>>> uploadCnicImages({
    required String token,
    required String frontImagePath,
    required String backImagePath,
  }) async {
    try {
      // Upload front image
      final frontResult = await uploadImage(
        token: token,
        filePath: frontImagePath,
      );
      String? frontUrl;
      frontResult.when(
        success: (url) => frontUrl = url,
        failure: (error) => throw Exception('Front image: $error'),
      );

      // Upload back image
      final backResult = await uploadImage(
        token: token,
        filePath: backImagePath,
      );
      String? backUrl;
      backResult.when(
        success: (url) => backUrl = url,
        failure: (error) => throw Exception('Back image: $error'),
      );

      if (frontUrl != null && backUrl != null) {
        return ApiResult.success({'front': frontUrl!, 'back': backUrl!});
      } else {
        return ApiResult.failure('Failed to upload CNIC images');
      }
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.getNetworkErrorMessage(e));
    }
  }
}
