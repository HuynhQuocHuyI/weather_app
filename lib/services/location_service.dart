import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../config/api_config.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      '${ApiConfig.geoBaseUrl}/direct?q=$query&limit=5&appid=${ApiConfig.apiKey}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => LocationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search location: ${response.statusCode}');
    }
  }

  Future<LocationModel> getLocationFromCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConfig.geoBaseUrl}/reverse?lat=$lat&lon=$lon&limit=1&appid=${ApiConfig.apiKey}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return LocationModel.fromJson(data[0]);
      }
      throw Exception('No location found for coordinates');
    } else {
      throw Exception('Failed to get location: ${response.statusCode}');
    }
  }
}
