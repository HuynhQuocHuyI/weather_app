class ForecastModel {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final double temp;
  final String main;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pop; 

  ForecastModel({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.temp,
    required this.main,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      temp: (json['main']['temp'] ?? 0).toDouble(),
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
      'date': date.millisecondsSinceEpoch,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'temp': temp,
      'main': main,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pop': pop,
    };
  }
}

class ForecastListModel {
  final String cityName;
  final String country;
  final List<ForecastModel> forecasts;

  ForecastListModel({
    required this.cityName,
    required this.country,
    required this.forecasts,
  });

  factory ForecastListModel.fromJson(Map<String, dynamic> json) {
    List<ForecastModel> forecastList = [];
    if (json['list'] != null) {
      forecastList = (json['list'] as List)
          .map((item) => ForecastModel.fromJson(item))
          .toList();
    }

    return ForecastListModel(
      cityName: json['city']['name'] ?? '',
      country: json['city']['country'] ?? '',
      forecasts: forecastList,
    );
  }
}
