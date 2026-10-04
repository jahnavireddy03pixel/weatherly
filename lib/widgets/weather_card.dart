
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../providers/favorites_provider.dart';
import '../services/weather_service.dart';
import '../utils/weather_utils.dart';

class WeatherCard extends StatefulWidget {
  final Map<String, dynamic> city;

  const WeatherCard({super.key, required this.city});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _service = WeatherService();
  late Future<dynamic> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _load();
  }

  Future<dynamic> _load() {
    return _service.fetchWeather(
      City(
        name: widget.city['name'] as String,
        country: widget.city['country'] as String,
        latitude: (widget.city['latitude'] as num).toDouble(),
        longitude: (widget.city['longitude'] as num).toDouble(),
      ),
    );
  }

  String _localTime(String raw) {
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
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(widget.city['name'] as String);

    return FutureBuilder(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: SizedBox(
              height: 185,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: SizedBox(
              height: 185,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 32),
                  const SizedBox(height: 6),
                  const Text('Weather unavailable'),
                  TextButton(
                    onPressed: () => setState(() => _weatherFuture = _load()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final weather = snapshot.data!;
        final background = weatherCardColor(
          code: weather.weatherCode,
          temperature: weather.temperature,
          precipitationProbability: weather.precipitationProbability,
        );
        final foreground = weatherTextColor(background);

        return Card(
          margin: EdgeInsets.zero,
          color: background,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              '/details',
              arguments: widget.city,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.city['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => favorites.toggleFavorite(widget.city),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(isFavorite),
                            color: foreground,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.city['country'] as String,
                    style: TextStyle(
                      color: foreground.withValues(alpha: 0.72),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        weatherEmoji(weather.weatherCode),
                        style: const TextStyle(fontSize: 34),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTemperature(weather.temperature),
                        style: TextStyle(
                          color: foreground,
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    weatherLabel(weather.weatherCode),
                    style: TextStyle(
                      color: foreground,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: foreground.withValues(alpha: 0.75),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _localTime(weather.time),
                        style: TextStyle(
                          color: foreground.withValues(alpha: 0.82),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isRainOrStorm(weather.weatherCode)) ...[
                        const SizedBox(width: 10),
                        Icon(
                          Icons.water_drop_outlined,
                          size: 14,
                          color: foreground.withValues(alpha: 0.75),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${weather.precipitationProbability}% rain',
                          style: TextStyle(
                            color: foreground.withValues(alpha: 0.82),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
