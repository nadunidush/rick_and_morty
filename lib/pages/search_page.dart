import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/models/screen_sizes.dart';
import 'package:rick_and_morty/pages/episode_details_page.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/pages/rating_page.dart';
import 'package:rick_and_morty/pages/watch_list_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/search_page_widgets/search_episode_card.dart';
import 'package:rick_and_morty/widgets/shared/bottom_navbar.dart';
import 'package:rick_and_morty/widgets/shared/right_navbar.dart';

class SearchPage extends StatefulWidget {
  final RickAndMortyApiService apiService;
  final WatchlistManager watchlistManager;
  const SearchPage({
    super.key,
    required this.apiService,
    required this.watchlistManager,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Episode> _allEpisodes = [];
  List<Episode> _filteredEpisodes = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            apiService: widget.apiService,
            watchlistManager: widget.watchlistManager,
          ),
        ),
        (route) => false,
      );
    } else if (index == 1) {
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WatchlistPage(
            apiService: widget.apiService,
            watchlistManager: widget.watchlistManager,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllEpisodesForSearch();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  //Get All Episode from services
  Future<void> _fetchAllEpisodesForSearch() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _allEpisodes = await widget.apiService.fetchAllEpisodes();
      _filteredEpisodes = _allEpisodes;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching all episodes for search: $e');
      setState(() {
        _errorMessage = 'Failed to load episodes for search: $e';
        _isLoading = false;
      });
    }
  }

  //search function
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEpisodes = _allEpisodes.where((episode) {
        return episode.name.toLowerCase().contains(query) ||
            episode.episode.toLowerCase().contains(query);
      }).toList();
    });
  }

  //put rating for the episode
  void _updateEpisodeRating(int episodeId, double newRating) {
    setState(() {
      final index = _allEpisodes.indexWhere((e) => e.id == episodeId);
      if (index != -1) {
        _allEpisodes[index] = Episode(
          id: _allEpisodes[index].id,
          name: _allEpisodes[index].name,
          airDate: _allEpisodes[index].airDate,
          episode: _allEpisodes[index].episode,
          characters: _allEpisodes[index].characters,
          url: _allEpisodes[index].url,
          created: _allEpisodes[index].created,
          imageUrl: _allEpisodes[index].imageUrl,
          userRating: newRating,
        );

        _onSearchChanged();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return Scaffold(
      body: isMobile
          ? Column(
              children: [
                Expanded(child: _buildSearchPageContent(context)),
                buildBottomNavBar(
                  context,
                  'Search',
                  widget.apiService,
                  widget.watchlistManager,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildSearchPageContent(context)),
                buildRightNavBar(
                  context,
                  'Search',
                  widget.apiService,
                  widget.watchlistManager,
                ),
              ],
            ),
    );
  }

  Widget _buildSearchPageContent(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Search', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, color: Colors.white54, size: 24),
            ],
          ),
          const SizedBox(height: 24.0),

          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Pilot',
              suffixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32.0),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : _filteredEpisodes.isEmpty
              ? const Center(
                  child: Text(
                    'No episodes found matching your search.',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: isMobile ? 16.0 : 30.0,
                    mainAxisSpacing: isMobile ? 16.0 : 30.0,
                    childAspectRatio: isMobile ? 4.0 : 4.2,
                  ),
                  itemCount: _filteredEpisodes.length,
                  itemBuilder: (context, index) {
                    final episode = _filteredEpisodes[index];
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
                          _updateEpisodeRating(selectedEpisode.id, newRating);
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
