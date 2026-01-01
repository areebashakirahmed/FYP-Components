class StatisticsModel {
  final int totalVendors;
  final int totalReviews;
  final int totalEventsBooked;

  StatisticsModel({
    required this.totalVendors,
    required this.totalReviews,
    required this.totalEventsBooked,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalVendors: json['total_vendors'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      totalEventsBooked: json['total_events_booked'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_vendors': totalVendors,
      'total_reviews': totalReviews,
      'total_events_booked': totalEventsBooked,
    };
  }
}
