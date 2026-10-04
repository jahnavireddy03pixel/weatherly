
import 'package:flutter/material.dart';

String weatherLabel(int code) {
  if (code == 0) return 'Clear sky';
  if ([1, 2, 3].contains(code)) return 'Partly cloudy';
  if ([45, 48].contains(code)) return 'Foggy';
  if ([51, 53, 55, 56, 57].contains(code)) return 'Drizzle';
  if ([61, 63, 65, 66, 67].contains(code)) return 'Rain';
  if ([71, 73, 75, 77].contains(code)) return 'Snow';
  if ([80, 81, 82].contains(code)) return 'Rain showers';
  if ([85, 86].contains(code)) return 'Snow showers';
  if ([95, 96, 99].contains(code)) return 'Thunderstorm';
  return 'Unknown weather';
}

String weatherEmoji(int code) {
  if (code == 0) return '☀️';
  if ([1, 2, 3].contains(code)) return '⛅';
  if ([45, 48].contains(code)) return '🌫️';
  if ([51, 53, 55, 56, 57].contains(code)) return '🌦️';
  if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return '🌧️';
  if ([71, 73, 75, 77, 85, 86].contains(code)) return '❄️';
  if ([95, 96, 99].contains(code)) return '⛈️';
  return '🌤️';
}

String formatTemperature(double value) => '${value.round()}°C';

bool isRainOrStorm(int code) => [
      51, 53, 55, 56, 57,
      61, 63, 65, 66, 67,
      80, 81, 82,
      95, 96, 99,
    ].contains(code);

bool isSunny(int code) => code == 0;
Color weatherCardColor({
  required int code,
  required double temperature,
  required int precipitationProbability,
}) {
  // Rain and storms always use grey shades.
  if (isRainOrStorm(code)) {
    final t = (precipitationProbability / 100).clamp(0.0, 1.0);

    return Color.lerp(
      const Color(0xFFD8DBE0), // ash grey
      const Color(0xFF343842), // dark grey
      t,
    )!;
  }

  // 15°C and below always use blue shades.
  // 15°C = light blue.
  // Lower temperature = darker blue.
  if (temperature <= 18) {
    final t = ((15 - temperature) / 25).clamp(0.0, 1.0);

    return Color.lerp(
      const Color(0xFFAED9FF), // light blue at 15°C
      const Color(0xFF123A70), // dark blue at very low temperatures
      t,
    )!;
  }

  // Sunny weather above 15°C:
  // lower temperature = more yellow
  // higher temperature = more orange
  if (isSunny(code)) {
    final t = ((temperature - 15) / 30).clamp(0.0, 1.0);

    return Color.lerp(
      const Color(0xFFFFF1A6), // yellow
      const Color(0xFFF28C28), // orange
      t,
    )!;
  }

  // Normal / partly cloudy weather.
  return Colors.white;
}

Color weatherTextColor(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : const Color(0xFF172033);
}
