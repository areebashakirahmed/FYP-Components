import 'package:mehfilista/features/location/models/area_model.dart';

class CityModel {
  final String id;
  final String name;
  final String country;
  final bool isActive;
  final List<AreaModel> areas;

  CityModel({
    required this.id,
    required this.name,
    this.country = 'Pakistan',
    this.isActive = true,
    this.areas = const [],
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? 'Pakistan',
      isActive: json['is_active'] ?? true,
      areas:
          (json['areas'] as List?)
              ?.map((e) => AreaModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'is_active': isActive,
      'areas': areas.map((e) => e.toJson()).toList(),
    };
  }
}
