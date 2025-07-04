import 'package:flutter/material.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/main.dart_widgets/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RickAndMortyApiService apiService = RickAndMortyApiService();
    final WatchlistManager watchlistManager = WatchlistManager();

    return MaterialApp(
      title: 'Rick and Morty Browser',
      debugShowCheckedModeBanner: false, 
      theme: themeDataMain,
      home: HomePage(apiService: apiService, watchlistManager: watchlistManager),
    );
  }
}