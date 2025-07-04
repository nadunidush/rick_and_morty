import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/models/screen_sizes.dart';
import 'package:rick_and_morty/pages/search_page.dart';
import 'package:rick_and_morty/pages/watch_list_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';
import 'package:rick_and_morty/widgets/shared/bottom_navbar.dart';
import 'package:rick_and_morty/widgets/home_page_widgets/content_card.dart';
import 'package:rick_and_morty/widgets/home_page_widgets/number_card.dart';
import 'package:rick_and_morty/widgets/shared/right_navbar.dart';

class HomePage extends StatefulWidget {
  final RickAndMortyApiService apiService;
  final WatchlistManager watchlistManager;
  const HomePage({super.key, required this.apiService, required this.watchlistManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Episode> _season1Episodes = []; 
  List<Character> _nowPlayingCharacters = [];
  List<Episode> _upcomingEpisodes = [];
  List<Character> _topRatedCharacters = [];
  List<Character> _popularCharacters = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'Now playing'; 

  //For the mobile view
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage(apiService: widget.apiService, watchlistManager: widget.watchlistManager)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WatchlistPage(apiService: widget.apiService, watchlistManager: widget.watchlistManager)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHomePageData();
  }

  Future<void> _fetchHomePageData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final allEpisodes = await widget.apiService.fetchAllEpisodes();
      _season1Episodes = allEpisodes.where((e) => e.episode.startsWith('S01')).toList();

      final allCharacters = await widget.apiService.fetchCharacters(1); 

  
      if (allCharacters.isNotEmpty) {
        _nowPlayingCharacters = allCharacters.sublist(0, allCharacters.length > 5 ? 5 : allCharacters.length);
        _topRatedCharacters = allCharacters.sublist(
            allCharacters.length > 5 ? 5 : 0, allCharacters.length > 10 ? 10 : allCharacters.length);
        _popularCharacters = allCharacters.sublist(
            allCharacters.length > 10 ? 10 : 0, allCharacters.length > 15 ? 15 : allCharacters.length);
      }

      _upcomingEpisodes = allEpisodes.where((e) => !e.episode.startsWith('S01')).toList();
      if (_upcomingEpisodes.length > 5) {
        _upcomingEpisodes = _upcomingEpisodes.sublist(0, 5); 
      }


      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching home page data: $e');
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  //selected category items
  Widget _buildContentForSelectedCategory() {
    List<String> imageUrls = [];
    switch (_selectedCategory) {
      case 'Now playing':
        imageUrls = _nowPlayingCharacters.map((e) => e.image).toList();
        break;
      case 'Upcoming':
        imageUrls = _upcomingEpisodes.map((e) => e.imageUrl ?? '').toList();
        break;
      case 'Top rated':
        imageUrls = _topRatedCharacters.map((e) => e.image).toList();
        break;
      case 'Popular':
        imageUrls = _popularCharacters.map((e) => e.image).toList();
        break;
      default:
        imageUrls = _nowPlayingCharacters.map((e) => e.image).toList(); 
    }

    if (imageUrls.isEmpty) {
      return const Center(
        child: Text(
          'No content available for this category.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return SizedBox(
      height: 220, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ContentCard(imageUrl: imageUrls[index]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return Scaffold(
      body: isMobile
          ? Column(
              children: [
                Expanded(child: _buildHomePageContent(context)),
                buildBottomNavBar(context, 'Home', widget.apiService, widget.watchlistManager),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildHomePageContent(context)),
                buildRightNavBar(context, 'Home', widget.apiService, widget.watchlistManager),
              ],
            ),
    );
  }

  //main content home page 
  Widget _buildHomePageContent(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0), 
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Rick and Morty',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 24.0),

                    SizedBox(
                      width: isMobile ? double.infinity : 300, 
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pilot', 
                          suffixIcon: const Icon(Icons.search), 
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 32.0),

 
                    SizedBox(
                      height: 220, 
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _season1Episodes.length,
                        itemBuilder: (context, index) {
                          final imageUrl = _season1Episodes[index].imageUrl ?? _season1Episodes[index].characters.firstWhere((url) => url.contains('image'), orElse: () => 'https://rickandmortyapi.com/api/character/avatar/1.jpeg'); // Fallback to Rick's image
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0), 
                            child: NumberedContentCard(
                              imageUrl: imageUrl,
                              number: index + 1, 
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    SingleChildScrollView( 
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryTitle('Now playing'),
                          const SizedBox(width: 30.0),
                          _buildCategoryTitle('Upcoming'),
                          const SizedBox(width: 30.0),
                          _buildCategoryTitle('Top rated'),
                          const SizedBox(width: 30.0),
                          _buildCategoryTitle('Popular'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    _buildContentForSelectedCategory(),
                  ],
                ),
    );
  }


  //category title
  Widget _buildCategoryTitle(String title) {
    final bool isActive = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.white54,
              fontFamily: 'Inter',
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 3.0,
              width: 30.0, 
              color: Colors.white, // Underline color
            ),
        ],
      ),
    );
  }
}