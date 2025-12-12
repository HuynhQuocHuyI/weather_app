import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const DailyForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              DateFormatter.formatDayName(forecast.date),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Icon(Icons.water_drop, size: 16, color: Colors.blue[300]),
              const SizedBox(width: 4),
              Text('${forecast.pop}%', style: TextStyle(color: Colors.blue[300], fontSize: 12)),
            ],
          ),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 40),
          ),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${forecast.tempMax.round()}°', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('${forecast.tempMin.round()}°', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
