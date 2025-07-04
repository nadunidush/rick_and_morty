import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/models/screen_sizes.dart';
import 'package:rick_and_morty/pages/home_page.dart';
import 'package:rick_and_morty/pages/search_page.dart';
import 'package:rick_and_morty/pages/watch_list_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';

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
  bool _isInWatchlist = false; // State for watchlist status

  // State for tabs
  String _selectedTab = 'About Movie'; // Default selected tab

  // Tracks the currently selected index for the BottomNavigationBar on mobile
  int _selectedIndex = 0; // Default, as this page doesn't have a direct nav item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate based on index
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WatchlistPage(apiService: widget.apiService, watchlistManager: widget.watchlistManager)),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEpisodeCharacters();
    _checkWatchlistStatus();
  }

  /// Checks if the current episode is in the user's watchlist.
  void _checkWatchlistStatus() {
    setState(() {
      _isInWatchlist = widget.watchlistManager.containsEpisode(widget.episode);
    });
  }

  /// Toggles the watchlist status of the current episode.
  void _toggleWatchlist() {
    if (_isInWatchlist) {
      widget.watchlistManager.removeEpisode(widget.episode);
    } else {
      widget.watchlistManager.addEpisode(widget.episode);
    }
    setState(() {
      _isInWatchlist = !_isInWatchlist; // Toggle local state
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInWatchlist ? 'Added to Watchlist!' : 'Removed from Watchlist!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Fetches characters that appear in this episode.
  Future<void> _fetchEpisodeCharacters() async {
    setState(() {
      _isLoadingCharacters = true;
      _charactersErrorMessage = null;
    });

    try {
      List<Character> fetchedCharacters = [];
      // Extract character IDs from the episode's character URLs
      List<int> characterIds = widget.episode.characters
          .map((url) => int.parse(url.split('/').last))
          .toList();

      // Fetch each character by ID
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
                _buildBottomNavBar(context, 'Detail', widget.apiService, widget.watchlistManager),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildEpisodeDetailContent(context)),
                _buildRightNavBar(context, 'Detail', widget.apiService, widget.watchlistManager),
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
          // Top Section: Image and Details Overlay
          Stack(
            clipBehavior: Clip.none, // Allow children to overflow
            children: [
              // Large Header Image
              SizedBox(
                height: isMobile ? 200 : 250, // Smaller height on mobile
                width: double.infinity,
                child: Image.network(
                  widget.episode.imageUrl ?? 'https://placehold.co/1200x250/2D3748/FFFFFF?text=Episode+Banner',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[700],
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 80)),
                    );
                  },
                ),
              ),
              // Back button and Bookmark icon
              Positioned(
                top: isMobile ? 16 : 32, // Smaller top padding on mobile
                left: isMobile ? 16 : 32,
                right: isMobile ? 16 : 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleWatchlist, // Toggle watchlist on tap
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isInWatchlist ? Icons.bookmark : Icons.bookmark_border, // Filled or outlined
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Episode Thumbnail and Title/Metadata
              Positioned(
                top: isMobile ? 150 : 200, // Adjust overlap for mobile
                left: horizontalPadding,
                right: horizontalPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Thumbnail
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.white, width: 2.0), // White border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          widget.episode.imageUrl ?? 'https://placehold.co/100x150/2D3748/FFFFFF?text=No+Image',
                          width: isMobile ? 80 : 100, // Smaller thumbnail on mobile
                          height: isMobile ? 120 : 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: isMobile ? 80 : 100,
                              height: isMobile ? 120 : 150,
                              color: Colors.grey[700],
                              child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 12.0 : 20.0), // Smaller spacing on mobile
                    // Title and Metadata
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.episode.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: isMobile ? 22 : 28, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isMobile ? 4.0 : 8.0), // Smaller spacing
                          Wrap(
                            spacing: isMobile ? 8.0 : 16.0, // Smaller spacing
                            runSpacing: isMobile ? 4.0 : 8.0,
                            children: [
                              _buildMetadataItem('2021', Icons.calendar_today), // Placeholder year
                              _buildMetadataItem('140 Minutes', Icons.timer), // Placeholder duration
                              _buildMetadataItem(widget.episode.episode, Icons.movie_filter),
                              _buildMetadataItem(
                                widget.episode.userRating > 0 ? widget.episode.userRating.toStringAsFixed(1) : 'N/A',
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Spacer to push content below the overlapped header
          SizedBox(height: isMobile ? 80 : 100), // Adjust based on thumbnail height and desired spacing

          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs: About Movie, Reviews, Cast
                SingleChildScrollView( // Make tabs scrollable if they overflow
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDetailTab('About Movie'),
                      const SizedBox(width: 30.0),
                      _buildDetailTab('Reviews'),
                      const SizedBox(width: 30.0),
                      _buildDetailTab('Cast'),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Content based on selected tab
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build metadata items (year, duration, episode code, rating).
  Widget _buildMetadataItem(String text, IconData icon, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Colors.white54, size: 16),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color ?? Colors.white54),
        ),
      ],
    );
  }

  /// Helper to build clickable detail tabs.
  Widget _buildDetailTab(String title) {
    final bool isActive = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
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
              width: 30.0, // Adjust width of the underline as needed
              color: Colors.white, // Underline color
            ),
        ],
      ),
    );
  }

  /// Renders content based on the selected tab.
  Widget _buildTabContent() {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    switch (_selectedTab) {
      case 'About Movie':
        return Text(
          'This is the "About Movie" section for ${widget.episode.name}. Here you would find a detailed description of the episode, its plot, and other relevant information. The Rick and Morty API does not provide detailed descriptions, so this is a placeholder.',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      case 'Reviews':
        return Text(
          'This is the "Reviews" section for ${widget.episode.name}. User reviews and ratings would be displayed here. This is a placeholder as the API does not provide review data.',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      case 'Cast':
        return _isLoadingCharacters
            ? const Center(child: CircularProgressIndicator())
            : _charactersErrorMessage != null
                ? Center(
                    child: Text(_charactersErrorMessage!, style: const TextStyle(color: Colors.red)),
                  )
                : _episodeCharacters.isEmpty
                    ? const Center(
                        child: Text(
                          'No cast information available for this episode.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : 4, // 2 columns for mobile, 4 for larger screens
                          crossAxisSpacing: isMobile ? 16.0 : 20.0,
                          mainAxisSpacing: isMobile ? 16.0 : 20.0,
                          childAspectRatio: 0.8, // Adjust aspect ratio for circular image + text
                        ),
                        itemCount: _episodeCharacters.length,
                        itemBuilder: (context, index) {
                          final character = _episodeCharacters[index];
                          return CastMemberCard(character: character);
                        },
                      );
      default:
        return Container();
    }
  }
}

/// A card widget to display a cast member (character).
class CastMemberCard extends StatelessWidget {
  final Character character;

  const CastMemberCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.network(
            character.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 100,
                color: Colors.grey[700],
                child: const Icon(Icons.person, color: Colors.white54, size: 50),
              );
            },
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: 100, // Constrain text width
          child: Text(
            character.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

Widget _buildRightNavBar(BuildContext context, String activePage, RickAndMortyApiService apiService, WatchlistManager watchlistManager) {
  return Container(
    width: 100, // Fixed width for the nav bar as in Figma
    color: const Color(0xFF2D3748), // Background color for nav bar from Figma
    padding: const EdgeInsets.symmetric(vertical: 32.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavBarItem(Icons.home, 'Home', activePage == 'Home', () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(apiService: apiService, watchlistManager: watchlistManager)),
            (route) => false, // Remove all previous routes
          );
        }),
        const SizedBox(height: 30.0),
        _buildNavBarItem(Icons.search, 'Search', activePage == 'Search', () {
          // Only navigate if not already on SearchPage
          if (activePage != 'Search') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage(apiService: apiService, watchlistManager: watchlistManager)),
            );
          }
        }),
        const SizedBox(height: 30.0),
        _buildNavBarItem(Icons.bookmark_border, 'Watch list', activePage == 'Watchlist', () {
          // Only navigate if not already on WatchlistPage
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


/// Helper function to build the bottom navigation bar (for mobile).
Widget _buildBottomNavBar(BuildContext context, String activePage, RickAndMortyApiService apiService, WatchlistManager watchlistManager) {
  int currentIndex = 0;
  if (activePage == 'Home') {
    currentIndex = 0;
  } else if (activePage == 'Search') {
    currentIndex = 1;
  } else if (activePage == 'Watchlist') {
    currentIndex = 2;
  } else {
    // For EpisodeDetailScreen, which doesn't have a direct nav item,
    // we can default to 0 or handle it differently if needed.
    // For now, let's assume it doesn't highlight any bottom nav item.
    currentIndex = 0; // Or -1 if you want no item selected
  }

  return BottomNavigationBar(
    backgroundColor: const Color(0xFF2D3748), // Match nav bar background
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

/// Helper to build individual navigation bar items (used by both nav bars).
Widget _buildNavBarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: isActive ? Colors.white : Colors.white54, // Active state color
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}