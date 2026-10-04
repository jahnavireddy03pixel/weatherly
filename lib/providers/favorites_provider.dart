import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String cityName) {
    return _favorites.any((city) => city['name'] == cityName);
  }

  void toggleFavorite(Map<String, dynamic> city) {
    final index =
        _favorites.indexWhere((item) => item['name'] == city['name']);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(Map<String, dynamic>.from(city));
    }

    notifyListeners();
  }
}
