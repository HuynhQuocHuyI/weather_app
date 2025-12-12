import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey => dotenv.env['OPENWEATHERMAP_API_KEY'] ?? 'YOUR_API_KEY_HERE';
  
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoBaseUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String iconUrl = 'https://openweathermap.org/img/wn';
  
  static const String units = 'metric';
  static const String lang = 'en';
  
  static String currentWeather(double lat, double lon) =>
      '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=$units&lang=$lang';
  
  static String forecast(double lat, double lon) =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$units&lang=$lang';
  
  static String geocoding(String query) =>
      '$geoBaseUrl/direct?q=$query&limit=5&appid=$apiKey';
  
  static String reverseGeocoding(double lat, double lon) =>
      '$geoBaseUrl/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
  
  static String weatherIcon(String iconCode, {int size = 2}) =>
      '$iconUrl/$iconCode@${size}x.png';
}

