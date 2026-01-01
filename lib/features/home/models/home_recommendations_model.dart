import 'package:mehfilista/features/home/models/category_model.dart';
import 'package:mehfilista/features/home/models/statistics_model.dart';
import 'package:mehfilista/features/vendor/models/vendor_model.dart';

class HomeRecommendationsModel {
  final List<VendorModel> featuredVendors;
  final List<CategoryModel> popularCategories;
  final List<VendorModel> recentVendors;
  final StatisticsModel statistics;

  HomeRecommendationsModel({
    required this.featuredVendors,
    required this.popularCategories,
    required this.recentVendors,
    required this.statistics,
  });

  factory HomeRecommendationsModel.fromJson(Map<String, dynamic> json) {
    return HomeRecommendationsModel(
      featuredVendors:
          (json['featured_vendors'] as List<dynamic>?)
              ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      popularCategories:
          (json['popular_categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentVendors:
          (json['recent_vendors'] as List<dynamic>?)
              ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statistics: json['statistics'] != null
          ? StatisticsModel.fromJson(json['statistics'] as Map<String, dynamic>)
          : StatisticsModel(
              totalVendors: 0,
              totalReviews: 0,
              totalEventsBooked: 0,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured_vendors': featuredVendors.map((e) => e.toJson()).toList(),
      'popular_categories': popularCategories.map((e) => e.toJson()).toList(),
      'recent_vendors': recentVendors.map((e) => e.toJson()).toList(),
      'statistics': statistics.toJson(),
    };
  }
}
