import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/models/screen_sizes.dart'; 
import 'package:rick_and_morty/services/tmb_services.dart'; 
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/episode_details_page_widgets/episode_header_section.dart';
import 'package:rick_and_morty/widgets/episode_details_page_widgets/episode_tab_section.dart';
import 'package:rick_and_morty/widgets/shared/bottom_navbar.dart';
import 'package:rick_and_morty/widgets/shared/right_navbar.dart';

class EpisodeDetailScreen extends StatefulWidget {
  final Episode episode;
  final RickAndMortyApiService apiService;
  final WatchlistManager watchlistManager;

  const EpisodeDetailScreen({
    super.key,
    required this.episode,
    required this.apiService,
    required this.watchlistManager,
  });

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> {
  List<Character> _episodeCharacters = [];
  bool _isLoadingCharacters = true;
  String? _charactersErrorMessage;
  bool _isInWatchlist = false;



  @override
  void initState() {
    super.initState();
    _fetchEpisodeCharacters();
    _checkWatchlistStatus();
  }

  //Checks if the current episode is in the user's watchlist.
  void _checkWatchlistStatus() {
    setState(() {
      _isInWatchlist = widget.watchlistManager.containsEpisode(widget.episode);
    });
  }

  //watchlist status of the current episode.
  void _toggleWatchlist() {
    if (_isInWatchlist) {
      widget.watchlistManager.removeEpisode(widget.episode);
    } else {
      widget.watchlistManager.addEpisode(widget.episode);
    }
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInWatchlist ? 'Added to Watchlist!' : 'Removed from Watchlist!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  //get characters that appear in this episode.
  Future<void> _fetchEpisodeCharacters() async {
    setState(() {
      _isLoadingCharacters = true;
      _charactersErrorMessage = null;
    });

    try {
      List<Character> fetchedCharacters = [];
      List<int> characterIds = widget.episode.characters
          .map((url) => int.parse(url.split('/').last))
          .toList();
      for (int id in characterIds) {
        try {
          final character = await widget.apiService.fetchCharacterById(id);
          fetchedCharacters.add(character);
        } catch (e) {
          print('Error fetching character ID $id for episode: $e');
        }
      }

      setState(() {
        _episodeCharacters = fetchedCharacters;
        _isLoadingCharacters = false;
      });
    } catch (e) {
      print('Error fetching characters for episode: $e');
      setState(() {
        _charactersErrorMessage = 'Failed to load cast: $e';
        _isLoadingCharacters = false;
      });
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
                Expanded(child: _buildEpisodeDetailContent(context)),
                buildBottomNavBar(context, 'Detail', widget.apiService, widget.watchlistManager),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildEpisodeDetailContent(context)),
                buildRightNavBar(context, 'Detail', widget.apiService, widget.watchlistManager),
              ],
            ),
    );
  }

  Widget _buildEpisodeDetailContent(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;
    final horizontalPadding = isMobile ? 16.0 : 32.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EpisodeHeaderSection(
            episode: widget.episode,
            isMobile: isMobile,
            horizontalPadding: horizontalPadding,
            isInWatchlist: _isInWatchlist,
            onToggleWatchlist: _toggleWatchlist,
          ),
          SizedBox(height: isMobile ? 80 : 100),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: EpisodeTabsSection(
              episode: widget.episode,
              isMobile: isMobile,
              episodeCharacters: _episodeCharacters,
              isLoadingCharacters: _isLoadingCharacters,
              charactersErrorMessage: _charactersErrorMessage,
            ),
          ),
        ],
      ),
    );
  }
}