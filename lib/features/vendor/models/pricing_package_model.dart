class PricingPackageModel {
  final String name;
  final String description;
  final String price;
  final List<String>? features;

  PricingPackageModel({
    required this.name,
    required this.description,
    required this.price,
    this.features,
  });

  factory PricingPackageModel.fromJson(Map<String, dynamic> json) {
    return PricingPackageModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      if (features != null) 'features': features,
    };
  }
}
