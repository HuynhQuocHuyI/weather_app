import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIconData(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  static Color getWeatherColor(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.grey;
      case 'rain':
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.deepPurple;
      case 'snow':
        return Colors.lightBlue;
      case 'mist':
      case 'fog':
      case 'haze':
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }

  static List<Color> getGradientColors(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF87CEEB), const Color(0xFF1E90FF)];
      case 'clouds':
        return [const Color(0xFF8E9EAB), const Color(0xFFeef2f3)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
      case 'thunderstorm':
        return [const Color(0xFF373B44), const Color(0xFF4286f4)];
      case 'snow':
        return [const Color(0xFFE6DADA), const Color(0xFF274046)];
      default:
        return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)];
    }
  }
}
