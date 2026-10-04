import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../services/weather_service.dart';
import '../widgets/section_title.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _service = WeatherService();

  List<Map<String, dynamic>> _cities = const [
    {
      'name': 'Hyderabad',
      'country': 'India',
      'latitude': 17.3850,
      'longitude': 78.4867,
    },
    {
      'name': 'Tokyo',
      'country': 'Japan',
      'latitude': 35.6762,
      'longitude': 139.6503,
    },
    {
      'name': 'London',
      'country': 'United Kingdom',
      'latitude': 51.5072,
      'longitude': -0.1276,
    },
    {
      'name': 'New York',
      'country': 'United States',
      'latitude': 40.7128,
      'longitude': -74.0060,
    },
    {
  'name': 'Multan',
  'country': 'Pakistan',
  'latitude': 30.1575,
  'longitude': 71.5249,
},
  ];

  List<Map<String, dynamic>> _results = [];
  bool _searching = false;

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _searching = true);

    try {
      final cities = await _service.searchCities(query);
      setState(() {
        _results = cities.map((city) => city.toJson()).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not search right now.')),
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weatherly',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => _showFavorites(context, favorites),
            icon: const Icon(Icons.favorite_outline),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-city'),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add city'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            const SizedBox(height: 8),
            Text(
              'Good weather starts\nwith knowing your sky.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search any city...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: _search,
                        icon: const Icon(Icons.arrow_forward),
                      ),
              ),
            ),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionTitle(
                title: 'Search results',
                subtitle: 'Tap a city to open its live weather.',
              ),
              const SizedBox(height: 12),
              ..._results.map(
                (city) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.location_city),
                      ),
                      title: Text(city['name'] as String),
                      subtitle: Text(city['country'] as String),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: city,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            const SectionTitle(
              title: 'Explore cities',
              subtitle: 'Live conditions from Open-Meteo.',
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width < 600
                    ? 1
                    : width < 1000
                        ? 2
                        : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: width < 600 ? 1.48 : 1.32,
                  ),
                  itemBuilder: (_, index) => WeatherCard(city: _cities[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFavorites(
    BuildContext context,
    List<Map<String, dynamic>> favorites,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        if (favorites.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 48),
                SizedBox(height: 12),
                Text('No favorite cities yet.'),
                SizedBox(height: 20),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            const Text(
              'Favorite cities',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...favorites.map(
              (city) => ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(city['name'] as String),
                subtitle: Text(city['country'] as String),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: city,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
