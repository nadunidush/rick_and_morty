import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/models/screen_sizes.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/pages/rating_page.dart';
import 'package:rick_and_morty/pages/search_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/search_page_widgets/search_episode_card.dart';
import 'package:rick_and_morty/widgets/shared/bottom_navbar.dart';
import 'package:rick_and_morty/widgets/shared/right_navbar.dart';

class WatchlistPage extends StatefulWidget {
  final RickAndMortyApiService apiService;
  final WatchlistManager watchlistManager;
  const WatchlistPage({super.key, required this.apiService, required this.watchlistManager});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  int _selectedIndex = 2; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(apiService: widget.apiService, watchlistManager: widget.watchlistManager)),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SearchPage(apiService: widget.apiService, watchlistManager: widget.watchlistManager)),
        (route) => false,
      );
    } else if (index == 2) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return Scaffold(
      body: isMobile
          ? Column(
              children: [
                Expanded(child: _buildWatchlistPageContent(context)),
                buildBottomNavBar(context, 'Watchlist', widget.apiService, widget.watchlistManager),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildWatchlistPageContent(context)),
                buildRightNavBar(context, 'Watchlist', widget.apiService, widget.watchlistManager),
              ],
            ),
    );
  }

  Widget _buildWatchlistPageContent(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;
    final horizontalPadding = isMobile ? 16.0 : 32.0;

    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watchlist',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: ValueListenableBuilder<List<Episode>>(
              valueListenable: widget.watchlistManager.watchlist,
              builder: (context, watchlistEpisodes, child) {
                if (watchlistEpisodes.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your watchlist is empty. Add episodes from the detail page!',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2, 
                    crossAxisSpacing: isMobile ? 16.0 : 30.0,
                    mainAxisSpacing: isMobile ? 16.0 : 30.0,
                    childAspectRatio: isMobile ? 3.0 : 2.2, 
                  ),
                  itemCount: watchlistEpisodes.length,
                  itemBuilder: (context, index) {
                    final episode = watchlistEpisodes[index];
                    return SearchEpisodeCard(
                      episode: episode,
                      apiService: widget.apiService,
                      watchlistManager: widget.watchlistManager,
                      onRateClicked: (selectedEpisode) async {
                        final double? newRating = await showDialog<double>(
                          context: context,
                          builder: (BuildContext context) {
                            return RatingDialog(
                              initialRating: selectedEpisode.userRating,
                            );
                          },
                        );
                        if (newRating != null) {
                          widget.watchlistManager.removeEpisode(selectedEpisode); 
                          selectedEpisode.userRating = newRating; 
                          widget.watchlistManager.addEpisode(selectedEpisode); 
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


