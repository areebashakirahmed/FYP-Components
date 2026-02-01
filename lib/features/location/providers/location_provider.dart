import 'package:flutter/foundation.dart';
import 'package:mehfilista/features/location/models/city_model.dart';
import 'package:mehfilista/features/location/models/area_model.dart';
import 'package:mehfilista/features/location/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  List<CityModel> _cities = [];
  List<AreaModel> _areasForSelectedCity = [];
  String? _selectedCity;
  String? _selectedArea;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CityModel> get cities => _cities;
  List<AreaModel> get areasForSelectedCity => _areasForSelectedCity;
  String? get selectedCity => _selectedCity;
  String? get selectedArea => _selectedArea;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Load all cities with their areas
  Future<void> loadCities({bool activeOnly = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _locationService.getCitiesWithAreas(
      activeOnly: activeOnly,
    );

    result.when(
      success: (data) {
        _cities = data;
        _error = null;
      },
      failure: (error) {
        _error = error;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Select a city and update available areas
  void selectCity(String cityName) {
    _selectedCity = cityName;
    _selectedArea = null;

    // Find areas for the selected city
    final city = _cities.firstWhere(
      (c) => c.name == cityName,
      orElse: () => CityModel(id: '', name: ''),
    );
    _areasForSelectedCity = city.areas;

    notifyListeners();
  }

  /// Select an area
  void selectArea(String areaName) {
    _selectedArea = areaName;
    notifyListeners();
  }

  /// Clear selection
  void clearSelection() {
    _selectedCity = null;
    _selectedArea = null;
    _areasForSelectedCity = [];
    notifyListeners();
  }

  /// Get city names for dropdown
  List<String> get cityNames => _cities.map((c) => c.name).toList();

  /// Get area names for dropdown (for selected city)
  List<String> get areaNames =>
      _areasForSelectedCity.map((a) => a.name).toList();
}
