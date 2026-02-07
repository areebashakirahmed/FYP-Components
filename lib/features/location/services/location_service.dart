import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/location/models/city_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class LocationService {
  /// Get all available cities
  /// API: GET /locations/cities
  /// Returns: { "cities": ["Karachi", "Lahore", ...] }
  Future<ApiResult<List<String>>> getCities() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.cities),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cityList = List<String>.from(data['cities'] ?? []);
        return ApiResult.success(cityList);
      } else {
        return ApiResult.failure('Failed to load cities: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Get all areas for a specific city
  /// API: GET /locations/cities/{city}/areas
  /// Returns: { "city": "Karachi", "areas": ["Gulshan", "DHA", ...] }
  Future<ApiResult<List<String>>> getCityAreas(String city) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.cityAreas(city)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final areaList = List<String>.from(data['areas'] ?? []);
        return ApiResult.success(areaList);
      } else {
        return ApiResult.failure('Failed to load areas: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }

  /// Legacy: Get all cities with their areas in one call
  /// Fallback if new endpoints aren't available
  Future<ApiResult<List<CityModel>>> getCitiesWithAreas({
    bool activeOnly = true,
  }) async {
    try {
      final uri = Uri.parse(
        ApiConstants.citiesWithAreas,
      ).replace(queryParameters: {'active_only': activeOnly.toString()});

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final cities = data.map((e) => CityModel.fromJson(e)).toList();
        return ApiResult.success(cities);
      } else {
        return ApiResult.failure('Failed to load locations: ${response.body}');
      }
    } catch (e) {
      return ApiResult.failure('Network error: $e');
    }
  }
}
