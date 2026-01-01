class LocationModel {
  final String name;
  final int vendorCount;

  LocationModel({required this.name, required this.vendorCount});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      vendorCount: json['vendor_count'] ?? json['vendorCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'vendor_count': vendorCount};
  }
}
