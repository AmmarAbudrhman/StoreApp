class ApiConstants {
  static const String baseUrl = 'https://storeapp.runasp.net';
  static const String apiVersion = '/api/v1';

  // Auth Endpoints
  static const String authBase = '$apiVersion/auth';
  static const String register = '$authBase/register';
  static const String login = '$authBase/login';
  static const String forgotPassword = '$authBase/forgot-password';
  static const String resetPassword = '$authBase/reset-password';
  static const String profile = '$authBase/profile';

  // Product Endpoints (adjust according to your API)
  static const String products = '$apiVersion/products';
  static const String categories = '$apiVersion/categories';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
}
