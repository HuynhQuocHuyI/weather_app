import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import '../config/api_config.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/weather?lat=$lat&lon=$lon&appid=${ApiConfig.apiKey}&units=${ApiConfig.units}&lang=${ApiConfig.lang}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/weather?q=$cityName&appid=${ApiConfig.apiKey}&units=${ApiConfig.units}&lang=${ApiConfig.lang}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<ForecastListModel> getForecast(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/forecast?lat=$lat&lon=$lon&appid=${ApiConfig.apiKey}&units=${ApiConfig.units}&lang=${ApiConfig.lang}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ForecastListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  Future<List<HourlyWeatherModel>> getHourlyForecast(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/forecast?lat=$lat&lon=$lon&appid=${ApiConfig.apiKey}&units=${ApiConfig.units}&lang=${ApiConfig.lang}&cnt=24',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['list'] as List;
      return list.map((item) => HourlyWeatherModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load hourly forecast: ${response.statusCode}');
    }
  }

  Future<List<ForecastModel>> getDailyForecast(double lat, double lon) async {
    final forecastList = await getForecast(lat, lon);
    
    Map<String, ForecastModel> dailyMap = {};
    for (var forecast in forecastList.forecasts) {
      String dateKey = '${forecast.date.year}-${forecast.date.month}-${forecast.date.day}';
      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = forecast;
      }
    }
    
    return dailyMap.values.toList();
  }
}
