/// Pricing tier model with base price and per-head pricing
class PricingTier {
  final String description;
  final double basePrice;
  final double perHeadPrice;

  PricingTier({
    required this.description,
    required this.basePrice,
    required this.perHeadPrice,
  });

  factory PricingTier.fromJson(Map<String, dynamic> json) {
    return PricingTier(
      description: json['description'] ?? '',
      basePrice: (json['base_price'] ?? 0).toDouble(),
      perHeadPrice: (json['per_head_price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'base_price': basePrice,
      'per_head_price': perHeadPrice,
    };
  }

  /// Calculate total cost based on number of guests
  double calculateCost(int numberOfGuests) {
    return basePrice + (perHeadPrice * numberOfGuests);
  }
}
