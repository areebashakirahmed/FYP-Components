class CategoryModel {
  final String name;
  final int count;
  final String icon;

  CategoryModel({required this.name, required this.count, required this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'count': count, 'icon': icon};
  }
}
