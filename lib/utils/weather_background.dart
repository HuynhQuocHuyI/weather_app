import 'package:flutter/material.dart';

class WeatherBackground {
  static List<Color> getGradientColors(String condition, bool isNight) {
    if (isNight) {
      return _getNightGradient(condition);
    }
    return _getDayGradient(condition);
  }

  static List<Color> _getDayGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF2193b0), const Color(0xFF6dd5ed), Colors.white];
      case 'clouds':
        return [const Color(0xFF757F9A), const Color(0xFFD7DDE8), Colors.white];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF373B44), const Color(0xFF4286f4), Colors.white];
      case 'thunderstorm':
        return [const Color(0xFF232526), const Color(0xFF414345), Colors.white];
      case 'snow':
        return [const Color(0xFFE8E8E8), const Color(0xFFA5C9CA), Colors.white];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFFbdc3c7), const Color(0xFF2c3e50), Colors.white];
      default:
        return [const Color(0xFF2193b0), const Color(0xFF6dd5ed), Colors.white];
    }
  }

  static List<Color> _getNightGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)];
      case 'clouds':
        return [const Color(0xFF141E30), const Color(0xFF243B55), const Color(0xFF141E30)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)];
      case 'thunderstorm':
        return [const Color(0xFF0d0d0d), const Color(0xFF1a1a2e), const Color(0xFF16213e)];
      case 'snow':
        return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF), const Color(0xFF2C3E50)];
      default:
        return [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)];
    }
  }

  static bool isNight(DateTime sunrise, DateTime sunset, DateTime current) {
    return current.isBefore(sunrise) || current.isAfter(sunset);
  }
}
