import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mehfilista/features/location/models/city_model.dart';
import 'package:mehfilista/utils/constants/api_constants.dart';
import 'package:mehfilista/utils/api_result.dart';

class LocationService {
  /// Get all cities with their areas
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
