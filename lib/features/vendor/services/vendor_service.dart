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
  /// Supports new API fields: CNIC, WhatsApp, pricing tiers, city/area
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
    List<Map<String, dynamic>>? pricingPackages,
    // New fields
    String? whatsappNumber,
    String? city,
    String? area,
    String? cnicNumber,
    String? cnicFrontImage,
    String? cnicBackImage,
    Map<String, dynamic>? basicPackage,
    Map<String, dynamic>? premiumPackage,
    Map<String, dynamic>? luxuryPackage,
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
      if (pricingPackages != null && pricingPackages.isNotEmpty) {
        body['pricing_packages'] = pricingPackages;
      }
      // New fields
      if (whatsappNumber != null && whatsappNumber.isNotEmpty) {
        body['whatsapp_number'] = whatsappNumber;
      }
      if (city != null && city.isNotEmpty) {
        body['city'] = city;
      }
      if (area != null && area.isNotEmpty) {
        body['area'] = area;
      }
      if (cnicNumber != null && cnicNumber.isNotEmpty) {
        body['cnic_number'] = cnicNumber;
      }
      if (cnicFrontImage != null && cnicFrontImage.isNotEmpty) {
        body['cnic_front_image'] = cnicFrontImage;
      }
      if (cnicBackImage != null && cnicBackImage.isNotEmpty) {
        body['cnic_back_image'] = cnicBackImage;
      }
      if (basicPackage != null) {
        body['basic_package'] = basicPackage;
      }
      if (premiumPackage != null) {
        body['premium_package'] = premiumPackage;
      }
      if (luxuryPackage != null) {
        body['luxury_package'] = luxuryPackage;
      }
      if (pricingPackages != null && pricingPackages.isNotEmpty) {
        body['pricing_packages'] = pricingPackages;
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
  /// Supports new API fields: CNIC, WhatsApp, pricing tiers, city/area
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
    List<Map<String, dynamic>>? pricingPackages,
    // New fields
    String? whatsappNumber,
    String? city,
    String? area,
    String? cnicNumber,
    String? cnicFrontImage,
    String? cnicBackImage,
    Map<String, dynamic>? basicPackage,
    Map<String, dynamic>? premiumPackage,
    Map<String, dynamic>? luxuryPackage,
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
      if (pricingPackages != null) body['pricing_packages'] = pricingPackages;
      // New fields
      if (whatsappNumber != null) body['whatsapp_number'] = whatsappNumber;
      if (city != null) body['city'] = city;
      if (area != null) body['area'] = area;
      if (cnicNumber != null) body['cnic_number'] = cnicNumber;
      if (cnicFrontImage != null) body['cnic_front_image'] = cnicFrontImage;
      if (cnicBackImage != null) body['cnic_back_image'] = cnicBackImage;
      if (basicPackage != null) body['basic_package'] = basicPackage;
      if (premiumPackage != null) body['premium_package'] = premiumPackage;
      if (luxuryPackage != null) body['luxury_package'] = luxuryPackage;

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

      // Add the file with proper field name
      final file = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResult.success(VendorModel.fromJson(data));
      } else if (response.statusCode == 403) {
        return ApiResult.failure('You can only upload to your own portfolio');
      } else if (response.statusCode == 400) {
        return ApiResult.failure(
          'Please upload a valid image (JPEG, PNG, or WebP)',
        );
      } else {
        // Try to parse error message from response
        try {
          final errorData = jsonDecode(response.body);
          final detail = errorData['detail'] ?? 'Failed to upload image';
          return ApiResult.failure(detail.toString());
        } catch (_) {
          return ApiResult.failure(
            'Failed to upload image (${response.statusCode})',
          );
        }
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Upload a file and get the URL (generic upload)
  Future<ApiResult<String>> uploadFile({
    required String token,
    required String filePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadFile),
      );
      request.headers['Authorization'] = 'Bearer $token';

      final file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final fileUrl = data['url'] ?? data['file_url'] ?? '';
        return ApiResult.success(fileUrl);
      } else {
        return ApiResult.failure('Failed to upload file: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Upload CNIC images for verification (Vendor only)
  Future<ApiResult<Map<String, String>>> uploadCnicImages({
    required String token,
    required String frontImagePath,
    required String backImagePath,
  }) async {
    try {
      // Upload front image
      final frontResult = await uploadFile(
        token: token,
        filePath: frontImagePath,
      );
      String? frontUrl;
      frontResult.when(
        success: (url) => frontUrl = url,
        failure: (error) => throw Exception('Front image: $error'),
      );

      // Upload back image
      final backResult = await uploadFile(
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
      return ApiResult.failure('Error uploading CNIC: $e');
    }
  }
}
