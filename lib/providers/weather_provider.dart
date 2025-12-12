import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _dailyForecast = [];
  List<HourlyWeatherModel> _hourlyForecast = [];
  WeatherStatus _status = WeatherStatus.initial;
  String _errorMessage = '';

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get dailyForecast => _dailyForecast;
  List<HourlyWeatherModel> get hourlyForecast => _hourlyForecast;
  WeatherStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeather(double lat, double lon) async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather(lat, lon);
      _dailyForecast = await _weatherService.getDailyForecast(lat, lon);
      _hourlyForecast = await _weatherService.getHourlyForecast(lat, lon);
      
      if (_currentWeather != null) {
        await _storageService.cacheWeather(_currentWeather!);
      }
      
      _status = WeatherStatus.loaded;
      _errorMessage = '';
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
      
      _currentWeather = await _storageService.getCachedWeather();
      if (_currentWeather != null) {
        _status = WeatherStatus.loaded;
      }
    }
    
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      
      if (_currentWeather != null) {
        _dailyForecast = await _weatherService.getDailyForecast(
          _currentWeather!.lat,
          _currentWeather!.lon,
        );
        _hourlyForecast = await _weatherService.getHourlyForecast(
          _currentWeather!.lat,
          _currentWeather!.lon,
        );
        
        await _storageService.cacheWeather(_currentWeather!);
      }
      
      _status = WeatherStatus.loaded;
      _errorMessage = '';
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeather(_currentWeather!.lat, _currentWeather!.lon);
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
