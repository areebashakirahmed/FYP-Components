class AreaModel {
  final String id;
  final String name;
  final bool isActive;

  AreaModel({required this.id, required this.name, this.isActive = true});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'is_active': isActive};
  }
}
