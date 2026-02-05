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

  // Fallback cities for Pakistan (used when API returns empty)
  static final List<CityModel> _fallbackCities = [
    CityModel(
      id: '1',
      name: 'Karachi',
      areas: [
        AreaModel(id: '1', name: 'Clifton'),
        AreaModel(id: '2', name: 'DHA'),
        AreaModel(id: '3', name: 'Gulshan-e-Iqbal'),
        AreaModel(id: '4', name: 'North Nazimabad'),
        AreaModel(id: '5', name: 'Saddar'),
        AreaModel(id: '6', name: 'Malir'),
        AreaModel(id: '7', name: 'Korangi'),
      ],
    ),
    CityModel(
      id: '2',
      name: 'Lahore',
      areas: [
        AreaModel(id: '8', name: 'Gulberg'),
        AreaModel(id: '9', name: 'DHA'),
        AreaModel(id: '10', name: 'Johar Town'),
        AreaModel(id: '11', name: 'Model Town'),
        AreaModel(id: '12', name: 'Bahria Town'),
        AreaModel(id: '13', name: 'Cantt'),
      ],
    ),
    CityModel(
      id: '3',
      name: 'Islamabad',
      areas: [
        AreaModel(id: '14', name: 'F-6'),
        AreaModel(id: '15', name: 'F-7'),
        AreaModel(id: '16', name: 'F-8'),
        AreaModel(id: '17', name: 'F-10'),
        AreaModel(id: '18', name: 'G-6'),
        AreaModel(id: '19', name: 'Blue Area'),
      ],
    ),
    CityModel(
      id: '4',
      name: 'Rawalpindi',
      areas: [
        AreaModel(id: '20', name: 'Saddar'),
        AreaModel(id: '21', name: 'Bahria Town'),
        AreaModel(id: '22', name: 'PWD'),
        AreaModel(id: '23', name: 'Satellite Town'),
      ],
    ),
    CityModel(
      id: '5',
      name: 'Faisalabad',
      areas: [
        AreaModel(id: '24', name: 'Peoples Colony'),
        AreaModel(id: '25', name: 'D Ground'),
        AreaModel(id: '26', name: 'Samanabad'),
        AreaModel(id: '27', name: 'Susan Road'),
      ],
    ),
    CityModel(
      id: '6',
      name: 'Multan',
      areas: [
        AreaModel(id: '28', name: 'Cantt'),
        AreaModel(id: '29', name: 'Gulgasht'),
        AreaModel(id: '30', name: 'Model Town'),
      ],
    ),
    CityModel(
      id: '7',
      name: 'Peshawar',
      areas: [
        AreaModel(id: '31', name: 'Hayatabad'),
        AreaModel(id: '32', name: 'University Town'),
        AreaModel(id: '33', name: 'Saddar'),
      ],
    ),
    CityModel(
      id: '8',
      name: 'Quetta',
      areas: [
        AreaModel(id: '34', name: 'Cantt'),
        AreaModel(id: '35', name: 'Satellite Town'),
      ],
    ),
  ];

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
        // If API returns empty, use fallback cities
        if (data.isEmpty) {
          _cities = _fallbackCities;
          _error = null;
        } else {
          _cities = data;
          _error = null;
        }
      },
      failure: (error) {
        // On error, use fallback cities instead of showing error
        _cities = _fallbackCities;
        _error = null; // Don't show error to user, just use fallback
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
