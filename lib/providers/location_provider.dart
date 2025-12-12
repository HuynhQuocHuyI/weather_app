import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum LocationStatus { initial, loading, loaded, error }

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  LocationModel? _currentLocation;
  List<LocationModel> _savedLocations = [];
  List<LocationModel> _searchResults = [];
  List<String> _searchHistory = [];
  LocationStatus _status = LocationStatus.initial;
  String _errorMessage = '';

  LocationModel? get currentLocation => _currentLocation;
  List<LocationModel> get savedLocations => _savedLocations;
  List<LocationModel> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  LocationStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> getCurrentLocation() async {
    _status = LocationStatus.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      _currentLocation = await _locationService.getLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (_currentLocation != null) {
        await _storageService.saveLastLocation(_currentLocation!);
      }
      
      _status = LocationStatus.loaded;
      _errorMessage = '';
    } catch (e) {
      _status = LocationStatus.error;
      _errorMessage = e.toString();
      
      _currentLocation = await _storageService.getLastLocation();
      if (_currentLocation != null) {
        _status = LocationStatus.loaded;
      }
    }
    
    notifyListeners();
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _locationService.searchLocation(query);
      await _storageService.addSearchHistory(query);
      await loadSearchHistory();
    } catch (e) {
      _searchResults = [];
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }

  Future<void> loadSearchHistory() async {
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> clearSearchHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  void setCurrentLocation(LocationModel location) {
    _currentLocation = location;
    _storageService.saveLastLocation(location);
    notifyListeners();
  }

  Future<void> loadSavedLocations() async {
    _savedLocations = await _storageService.getSavedLocations();
    notifyListeners();
  }

  Future<void> saveLocation(LocationModel location) async {
    await _storageService.saveLocation(location);
    await loadSavedLocations();
  }

  Future<void> removeLocation(LocationModel location) async {
    await _storageService.removeLocation(location);
    await loadSavedLocations();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
