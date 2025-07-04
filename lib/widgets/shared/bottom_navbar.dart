import 'package:flutter/material.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/pages/search_page.dart';
import 'package:rick_and_morty/pages/watch_list_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';

Widget buildBottomNavBar(BuildContext context, String activePage, RickAndMortyApiService apiService, WatchlistManager watchlistManager) {
  int currentIndex = 0;
  if (activePage == 'Home') {
    currentIndex = 0;
  } else if (activePage == 'Search') {
    currentIndex = 1;
  } else if (activePage == 'Watchlist') {
    currentIndex = 2;
  } else {
    currentIndex = 0; 
  }

  return BottomNavigationBar(
    backgroundColor: const Color(0xFF2D3748), 
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white54,
    currentIndex: currentIndex,
    onTap: (index) {
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(apiService: apiService, watchlistManager: watchlistManager)),
          (route) => false,
        );
      } else if (index == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SearchPage(apiService: apiService, watchlistManager: watchlistManager)),
          (route) => false,
        );
      } else if (index == 2) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WatchlistPage(apiService: apiService, watchlistManager: watchlistManager)),
          (route) => false,
        );
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark_border),
        label: 'Watch list',
      ),
    ],
  );
}