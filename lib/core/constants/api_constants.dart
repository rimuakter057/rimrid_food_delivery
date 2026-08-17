abstract class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  
  // Endpoints
  static const String categories = 'categories.php';
  static const String filterByCategory = 'filter.php';
  static const String searchByName = 'search.php';
  static const String lookupById = 'lookup.php';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
