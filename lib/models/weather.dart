
class Weather {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final int precipitationProbability;
  final String time;

  const Weather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = Map<String, dynamic>.from(json['current'] as Map);
    final hourly = Map<String, dynamic>.from(json['hourly'] as Map? ?? {});
    final probabilities =
        (hourly['precipitation_probability'] as List<dynamic>? ?? []);
    final times = (hourly['time'] as List<dynamic>? ?? []);

    var probability = 0;
    final currentTime = current['time']?.toString();

    if (currentTime != null) {
      final index = times.indexOf(currentTime);
      if (index >= 0 && index < probabilities.length) {
        probability = (probabilities[index] as num).round();
      }
    }

    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature:
          (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).round(),
      precipitationProbability: probability,
      time: current['time'].toString(),
    );
  }
}
