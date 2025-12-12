class HourlyWeatherModel {
  final DateTime dateTime;
  final double temp;
  final double feelsLike;
  final String main;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pop;

  HourlyWeatherModel({
    required this.dateTime,
    required this.temp,
    required this.feelsLike,
    required this.main,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temp: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      main: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      pop: ((json['pop'] ?? 0) * 100).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.millisecondsSinceEpoch,
      'temp': temp,
      'feelsLike': feelsLike,
      'main': main,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pop': pop,
    };
  }
}
