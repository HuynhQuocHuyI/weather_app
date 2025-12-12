import 'package:flutter/material.dart';
import '../models/hourly_weather_model.dart';
import '../utils/date_formatter.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyWeatherModel> hourlyForecast;

  const HourlyForecastList({super.key, required this.hourlyForecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hourly Forecast', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecast.length > 12 ? 12 : hourlyForecast.length,
              itemBuilder: (context, index) {
                final hour = hourlyForecast[index];
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormatter.formatHour(hour.dateTime), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Image.network(
                        'https://openweathermap.org/img/wn/${hour.icon}@2x.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 40),
                      ),
                      const SizedBox(height: 8),
                      Text('${hour.temp.round()}°', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
