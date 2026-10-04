import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/providers/favorites_provider.dart';
import 'package:weatherly/utils/weather_utils.dart';

void main() {
  group('Weather utility tests', () {
    test('weather code 0 is clear sky', () {
      expect(weatherLabel(0), 'Clear sky');
      expect(weatherEmoji(0), '☀️');
    });

    test('temperature is formatted correctly', () {
      expect(formatTemperature(28.6), '29°C');
    });
  });

  group('FavoritesProvider tests', () {
    test('toggle adds and removes a favorite city', () {
      final provider = FavoritesProvider();

      final city = {
        'name': 'Hyderabad',
        'country': 'India',
        'latitude': 17.3850,
        'longitude': 78.4867,
      };

      provider.toggleFavorite(city);

      expect(provider.isFavorite('Hyderabad'), isTrue);
      expect(provider.favorites.length, 1);

      provider.toggleFavorite(city);

      expect(provider.isFavorite('Hyderabad'), isFalse);
      expect(provider.favorites, isEmpty);
    });
  });
}