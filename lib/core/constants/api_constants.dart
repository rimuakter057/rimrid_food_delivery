abstract class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Endpoints
  static const String categories = 'categories.php';
  static const String filterByCategory = 'filter.php';
  static const String searchByName = 'search.php';
  static const String lookupById = 'lookup.php';
  static const String listAreas = 'list.php';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}

/// DummyJSON — free, keyless fake-auth API used for a real login/register HTTP flow.
abstract class AuthApiConstants {
  static const String baseUrl = 'https://dummyjson.com/';
  static const String login = 'auth/login';
  static const String addUser = 'users/add';

  /// DummyJSON only accepts its own fixed seed accounts for login.
  static const String demoUsername = 'emilys';
  static const String demoPassword = 'emilyspass';
}

/// OpenStreetMap Nominatim — free, keyless geocoding API for address search.
abstract class LocationApiConstants {
  static const String baseUrl = 'https://nominatim.openstreetmap.org/';
  static const String search = 'search';

  /// Nominatim's usage policy requires a descriptive User-Agent per request.
  static const String userAgent = 'rimrid_delivery Flutter app (portfolio project)';
}

/// randomuser.me — free, keyless API used to generate a real delivery-driver identity.
abstract class DriverApiConstants {
  static const String baseUrl = 'https://randomuser.me/';
  static const String randomUser = 'api/';
}
