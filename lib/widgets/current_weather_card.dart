import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/date_formatter.dart';
import 'weather_detail_item.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    int index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            '${weather.cityName}, ${weather.country}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormatter.formatFullDate(weather.dateTime),
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.cloud, size: 100, color: Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temp.round()}°',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherDetailItem(icon: Icons.water_drop, label: 'Humidity', value: '${weather.humidity}%'),
                    WeatherDetailItem(icon: Icons.air, label: 'Wind', value: '${weather.windSpeed} m/s ${_getWindDirection(weather.windDeg)}'),
                    WeatherDetailItem(icon: Icons.visibility, label: 'Visibility', value: '${(weather.visibility / 1000).toStringAsFixed(1)} km'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherDetailItem(icon: Icons.compress, label: 'Pressure', value: '${weather.pressure} hPa'),
                    WeatherDetailItem(icon: Icons.thermostat, label: 'Min/Max', value: '${weather.tempMin.round()}°/${weather.tempMax.round()}°'),
                    WeatherDetailItem(icon: Icons.cloud, label: 'Clouds', value: '${weather.clouds}%'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherDetailItem(icon: Icons.wb_sunny, label: 'Sunrise', value: DateFormatter.formatTime(weather.sunrise)),
                    WeatherDetailItem(icon: Icons.nights_stay, label: 'Sunset', value: DateFormatter.formatTime(weather.sunset)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
