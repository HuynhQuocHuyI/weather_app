import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart' as app_widgets;
import '../utils/weather_background.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final locationProvider = context.read<LocationProvider>();
    final weatherProvider = context.read<WeatherProvider>();
    
    await locationProvider.getCurrentLocation();
    
    if (locationProvider.currentLocation != null) {
      await weatherProvider.fetchWeather(
        locationProvider.currentLocation!.lat,
        locationProvider.currentLocation!.lon,
      );
    }
  }

  Future<void> _refreshWeather() async {
    await _loadWeather();
  }

  List<Color> _getBackgroundColors(WeatherProvider weatherProvider) {
    if (weatherProvider.currentWeather != null) {
      final weather = weatherProvider.currentWeather!;
      final isNight = WeatherBackground.isNight(
        weather.sunrise,
        weather.sunset,
        DateTime.now(),
      );
      return WeatherBackground.getGradientColors(weather.main, isNight);
    }
    return [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColor.withOpacity(0.7),
      Colors.white,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final gradientColors = _getBackgroundColors(weatherProvider);
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _refreshWeather,
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(weatherProvider),
                    SliverToBoxAdapter(
                      child: Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                          if (weatherProvider.status == WeatherStatus.loading ||
                              locationProvider.status == LocationStatus.loading) {
                            return const LoadingShimmer();
                          }

                          if (weatherProvider.status == WeatherStatus.error &&
                              weatherProvider.currentWeather == null) {
                            return app_widgets.ErrorWidget(
                              message: weatherProvider.errorMessage,
                              onRetry: _refreshWeather,
                            );
                          }

                          if (weatherProvider.currentWeather == null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('No weather data available'),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              CurrentWeatherCard(
                                weather: weatherProvider.currentWeather!,
                              ),
                              const SizedBox(height: 20),
                              if (weatherProvider.hourlyForecast.isNotEmpty)
                                HourlyForecastList(
                                  hourlyForecast: weatherProvider.hourlyForecast,
                                ),
                              const SizedBox(height: 20),
                              if (weatherProvider.dailyForecast.isNotEmpty)
                                ...weatherProvider.dailyForecast.map(
                                  (forecast) => DailyForecastCard(forecast: forecast),
                                ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(WeatherProvider weatherProvider) {
    final isNight = weatherProvider.currentWeather != null
        ? WeatherBackground.isNight(
            weatherProvider.currentWeather!.sunrise,
            weatherProvider.currentWeather!.sunset,
            DateTime.now(),
          )
        : false;
    final iconColor = isNight ? Colors.white70 : Colors.white;

    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Text(
            locationProvider.currentLocation?.displayName ?? 'Weather App',
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: iconColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: iconColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

