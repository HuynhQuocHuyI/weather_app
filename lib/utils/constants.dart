class AppConstants {
  // App Info
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';
  
  // Default Values
  static const double defaultLat = 21.0285; // Hanoi
  static const double defaultLon = 105.8542;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 30);
  
  // API Limits
  static const int maxSearchResults = 5;
  static const int maxSavedLocations = 10;
  
  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
}
