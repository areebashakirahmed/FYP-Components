class ApiConstants {
  static const String baseUrl = 'http://20.83.180.133:9000';

  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';
  static const String updateProfile = '$baseUrl/auth/me';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // Home endpoints
  static const String homeRecommendations = '$baseUrl/home/recommendations';
  static const String homeCategories = '$baseUrl/home/categories';
  static const String homeLocations = '$baseUrl/home/locations';

  // Vendors
  static const String vendorsSearch = '$baseUrl/vendors/search';
  static String vendorDetails(String id) => '$baseUrl/vendors/$id';
  static const String createVendor = '$baseUrl/vendors';
  static const String myVendor = '$baseUrl/vendors/me';
  static String updateVendor(String id) => '$baseUrl/vendors/$id';
  static String uploadPortfolio(String id) => '$baseUrl/vendors/$id/portfolio';

  // Inquiries
  static const String sendInquiry = '$baseUrl/inquiries';
  static const String myInquiries = '$baseUrl/inquiries/me';
  static const String vendorInquiries = '$baseUrl/inquiries/vendor/me';
  static String inquiryDetails(String id) => '$baseUrl/inquiries/$id';
  static String respondInquiry(String id) => '$baseUrl/inquiries/$id';

  // Reviews
  static const String leaveReview = '$baseUrl/reviews';
  static String vendorReviews(String vendorId) =>
      '$baseUrl/reviews/vendor/$vendorId';

  // Utility
  static const String apiRoot = '$baseUrl/';
  static const String healthCheck = '$baseUrl/health';
}
