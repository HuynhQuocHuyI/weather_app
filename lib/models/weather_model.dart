class WeatherModel {
  final int id;
  final String main;
  final String description;
  final String icon;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int clouds;
  final int visibility;
  final DateTime dateTime;
  final String cityName;
  final String country;
  final DateTime sunrise;
  final DateTime sunset;
  final double lat;
  final double lon;

  WeatherModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.visibility,
    required this.dateTime,
    required this.cityName,
    required this.country,
    required this.sunrise,
    required this.sunset,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json['weather'][0]['id'] ?? 0,
      main: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      temp: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDeg: json['wind']['deg'] ?? 0,
      clouds: json['clouds']['all'] ?? 0,
      visibility: json['visibility'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      sunrise: DateTime.fromMillisecondsSinceEpoch((json['sys']['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((json['sys']['sunset'] ?? 0) * 1000),
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weather': [
        {
          'id': id,
          'main': main,
          'description': description,
          'icon': icon,
        }
      ],
      'main': {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDeg,
      },
      'clouds': {'all': clouds},
      'visibility': visibility,
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      },
      'coord': {
        'lat': lat,
        'lon': lon,
      },
    };
  }
}

