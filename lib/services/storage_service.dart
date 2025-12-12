import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _savedLocationsKey = 'saved_locations';
  static const String _searchHistoryKey = 'search_history';
  static const String _lastWeatherKey = 'last_weather';
  static const String _lastWeatherTimeKey = 'last_weather_time';
  static const String _temperatureUnitKey = 'temperature_unit';
  static const String _windSpeedUnitKey = 'wind_speed_unit';
  static const String _timeFormatKey = 'time_format';
  static const String _themeKey = 'theme_mode';
  static const String _lastLocationKey = 'last_location';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<List<LocationModel>> getSavedLocations() async {
    final prefs = await _prefs;
    final String? locationsJson = prefs.getString(_savedLocationsKey);
    
    if (locationsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(locationsJson);
    return decoded.map((item) => LocationModel.fromJson(item)).toList();
  }

  Future<void> saveLocation(LocationModel location) async {
    final locations = await getSavedLocations();
    
    if (!locations.contains(location)) {
      locations.add(location);
      final prefs = await _prefs;
      await prefs.setString(
        _savedLocationsKey,
        json.encode(locations.map((l) => l.toJson()).toList()),
      );
    }
  }

  Future<void> removeLocation(LocationModel location) async {
    final locations = await getSavedLocations();
    locations.removeWhere((l) => l == location);
    
    final prefs = await _prefs;
    await prefs.setString(
      _savedLocationsKey,
      json.encode(locations.map((l) => l.toJson()).toList()),
    );
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await _prefs;
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> addSearchHistory(String query) async {
    final prefs = await _prefs;
    final history = await getSearchHistory();
    
    history.remove(query);
    history.insert(0, query);
    
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_searchHistoryKey);
  }

  Future<void> cacheWeather(WeatherModel weather) async {
    final prefs = await _prefs;
    await prefs.setString(_lastWeatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastWeatherTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await _prefs;
    final String? weatherJson = prefs.getString(_lastWeatherKey);
    
    if (weatherJson == null) return null;
    
    return WeatherModel.fromJson(json.decode(weatherJson));
  }

  Future<DateTime?> getCacheTime() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_lastWeatherTimeKey);
    
    if (timestamp == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<bool> isCacheOutdated() async {
    final cacheTime = await getCacheTime();
    if (cacheTime == null) return true;
    
    final diff = DateTime.now().difference(cacheTime);
    return diff.inMinutes > 30;
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await _prefs;
    return prefs.getString(_temperatureUnitKey) ?? 'metric';
  }

  Future<void> setTemperatureUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_temperatureUnitKey, unit);
  }

  Future<String> getWindSpeedUnit() async {
    final prefs = await _prefs;
    return prefs.getString(_windSpeedUnitKey) ?? 'm/s';
  }

  Future<void> setWindSpeedUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_windSpeedUnitKey, unit);
  }

  Future<String> getTimeFormat() async {
    final prefs = await _prefs;
    return prefs.getString(_timeFormatKey) ?? '24h';
  }

  Future<void> setTimeFormat(String format) async {
    final prefs = await _prefs;
    await prefs.setString(_timeFormatKey, format);
  }

  Future<String> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(_themeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await _prefs;
    await prefs.setString(_themeKey, mode);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await _prefs;
    await prefs.setString(_lastLocationKey, json.encode(location.toJson()));
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await _prefs;
    final String? locationJson = prefs.getString(_lastLocationKey);
    
    if (locationJson == null) return null;
    
    return LocationModel.fromJson(json.decode(locationJson));
  }
}
