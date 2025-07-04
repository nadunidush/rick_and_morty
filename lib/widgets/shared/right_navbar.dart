import 'package:flutter/material.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/pages/search_page.dart';
import 'package:rick_and_morty/pages/watch_list_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/shared/nav_bar_items.dart';

Widget buildRightNavBar(BuildContext context, String activePage, RickAndMortyApiService apiService, WatchlistManager watchlistManager) {
  return Container(
    width: 100, 
    color: const Color(0xFF2D3748), 
    padding: const EdgeInsets.symmetric(vertical: 32.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildNavBarItem(Icons.home, 'Home', activePage == 'Home', () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(apiService: apiService, watchlistManager: watchlistManager)),
            (route) => false, 
          );
        }),
        const SizedBox(height: 30.0),
        buildNavBarItem(Icons.search, 'Search', activePage == 'Search', () {
          if (activePage != 'Search') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage(apiService: apiService, watchlistManager: watchlistManager)),
            );
          }
        }),
        const SizedBox(height: 30.0),
        buildNavBarItem(Icons.bookmark_border, 'Watch list', activePage == 'Watchlist', () {
          if (activePage != 'Watchlist') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WatchlistPage(apiService: apiService, watchlistManager: watchlistManager)),
            );
          }
        }),
      ],
    ),
  );
}