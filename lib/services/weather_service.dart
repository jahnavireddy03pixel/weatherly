
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/weather.dart';

class WeatherService {
  static const _geocodingBase =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const _weatherBase = 'https://api.open-meteo.com/v1/forecast';

  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(_geocodingBase).replace(
      queryParameters: {
        'name': query.trim(),
        'count': '8',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Could not search for cities.');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (body['results'] as List<dynamic>? ?? []);

    return results
        .map((item) => City.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Weather> fetchWeather(City city) async {
    final uri = Uri.parse(_weatherBase).replace(
      queryParameters: {
        'latitude': city.latitude.toString(),
        'longitude': city.longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
        'hourly': 'precipitation_probability',
        'forecast_days': '1',
        'timezone': 'auto',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Could not fetch weather data.');
    }

    return Weather.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
