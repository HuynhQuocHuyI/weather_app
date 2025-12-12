import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/weather_provider.dart';
import '../models/location_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    final provider = context.read<LocationProvider>();
    provider.loadSavedLocations();
    provider.loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<LocationProvider>().searchLocations(query);
  }

  void _searchFromHistory(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
  }

  void _selectLocation(LocationModel location) async {
    final locationProvider = context.read<LocationProvider>();
    final weatherProvider = context.read<WeatherProvider>();

    locationProvider.setCurrentLocation(location);
    await weatherProvider.fetchWeather(location.lat, location.lon);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _saveLocation(LocationModel location) {
    context.read<LocationProvider>().saveLocation(location);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${location.name} saved!')),
    );
  }

  void _removeLocation(LocationModel location) {
    context.read<LocationProvider>().removeLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<LocationProvider>().clearSearchResults();
                setState(() {});
              },
            ),
        ],
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (_searchController.text.isNotEmpty &&
              locationProvider.searchResults.isNotEmpty) {
            return _buildSearchResults(locationProvider.searchResults);
          }

          return _buildSavedLocationsAndHistory(
            locationProvider.savedLocations,
            locationProvider.searchHistory,
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(List<LocationModel> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];
        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(location.name),
          subtitle: Text(location.displayName),
          trailing: IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => _saveLocation(location),
          ),
          onTap: () => _selectLocation(location),
        );
      },
    );
  }

  Widget _buildSavedLocationsAndHistory(
    List<LocationModel> savedLocations,
    List<String> searchHistory,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.my_location, size: 20),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    await context.read<LocationProvider>().getCurrentLocation();
                    final location = context.read<LocationProvider>().currentLocation;
                    if (location != null) {
                      _selectLocation(location);
                    }
                  },
                  child: const Text('Use current location'),
                ),
              ],
            ),
          ),
          const Divider(),
          if (searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<LocationProvider>().clearSearchHistory();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            ...searchHistory.map((query) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(query),
              onTap: () => _searchFromHistory(query),
            )),
            const Divider(),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Saved Locations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (savedLocations.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No saved locations')),
            )
          else
            ...savedLocations.map((location) => ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(location.name),
              subtitle: Text(location.displayName),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeLocation(location),
              ),
              onTap: () => _selectLocation(location),
            )),
        ],
      ),
    );
  }
}
