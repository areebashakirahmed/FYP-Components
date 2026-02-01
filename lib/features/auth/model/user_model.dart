class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String? city;
  final String? area;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.city,
    this.area,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      city: json['city'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
    };
  }
}
