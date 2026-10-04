import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'screens/add_city_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/weather_details_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: const WeatherlyApp(),
    ),
  );
}

class WeatherlyApp extends StatefulWidget {
  const WeatherlyApp({super.key});

  @override
  State<WeatherlyApp> createState() => _WeatherlyAppState();
}

class _WeatherlyAppState extends State<WeatherlyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weatherly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/add-city': (_) => const AddCityScreen(),
        '/settings': (_) => SettingsScreen(
              isDark: _themeMode == ThemeMode.dark,
              onThemeChanged: _toggleTheme,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final city = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => WeatherDetailsScreen(city: city),
          );
        }
        return null;
      },
    );
  }
}
