import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/home/models/category_model.dart';
import 'package:mehfilista/features/home/models/home_recommendations_model.dart';
import 'package:mehfilista/features/home/models/location_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class HomeService {
  /// Get homepage recommendations including featured vendors, categories, and stats
  Future<ApiResult<HomeRecommendationsModel>> getRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.homeRecommendations),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(HomeRecommendationsModel.fromJson(data));
      } else {
        return ApiResult.failure(
          'Failed to load recommendations: ${response.body}',
        );
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get all categories with counts and icons
  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.homeCategories),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final categories = data.map((e) => CategoryModel.fromJson(e)).toList();
        return ApiResult.success(categories);
      } else {
        return ApiResult.failure('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get popular locations with vendor counts
  Future<ApiResult<List<LocationModel>>> getLocations() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.homeLocations),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final locations = data.map((e) => LocationModel.fromJson(e)).toList();
        return ApiResult.success(locations);
      } else {
        return ApiResult.failure('Failed to load locations: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Health check endpoint
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.healthCheck));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
