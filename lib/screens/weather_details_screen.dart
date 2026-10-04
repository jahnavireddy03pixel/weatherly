import 'package:flutter/material.dart';

import '../models/city.dart';
import '../services/weather_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/stat_tile.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  const WeatherDetailsScreen({super.key, required this.city});

  String _formatLocalTime(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.replaceFirst('T', ' ');

    final hour = parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final cityModel = City(
      name: city['name'] as String,
      country: city['country'] as String,
      latitude: (city['latitude'] as num).toDouble(),
      longitude: (city['longitude'] as num).toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(cityModel.name),
      ),
      body: FutureBuilder(
        future: WeatherService().fetchWeather(cityModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 60),
                    const SizedBox(height: 12),
                    const Text('Weather data could not be loaded.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        weatherEmoji(weather.weatherCode),
                        style: const TextStyle(fontSize: 72),
                      ),
                      Text(
                        formatTemperature(weather.temperature),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherLabel(weather.weatherCode),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${cityModel.name}, ${cityModel.country}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Local time: ${_formatLocalTime(weather.time)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width < 600 ? 1 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.8,
                children: [
                  StatTile(
                    icon: Icons.thermostat,
                    label: 'Feels like',
                    value: formatTemperature(weather.apparentTemperature),
                  ),
                  StatTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Humidity',
                    value: '${weather.humidity}%',
                  ),
                  StatTile(
                    icon: Icons.air,
                    label: 'Wind',
                    value: '${weather.windSpeed.round()} km/h',
                  ),
                  StatTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Rain probability',
                    value: '${weather.precipitationProbability}%',
                  ),
                  StatTile(
                    icon: Icons.access_time,
                    label: 'Updated',
                    value: weather.time.replaceFirst('T', ' '),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
