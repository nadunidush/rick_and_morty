
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart'; 
import 'package:rick_and_morty/widgets/episode_details_page_widgets/cast_memeber_card.dart';

class EpisodeTabsSection extends StatefulWidget {
  final Episode episode;
  final bool isMobile;
  final List<Character> episodeCharacters;
  final bool isLoadingCharacters;
  final String? charactersErrorMessage;

  const EpisodeTabsSection({
    super.key,
    required this.episode,
    required this.isMobile,
    required this.episodeCharacters,
    required this.isLoadingCharacters,
    required this.charactersErrorMessage,
  });

  @override
  State<EpisodeTabsSection> createState() => _EpisodeTabsSectionState();
}

class _EpisodeTabsSectionState extends State<EpisodeTabsSection> {
  String _selectedTab = 'About Movie';

  //Helper to build clickable detail tabs.
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
              width: 30.0, 
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  //tab content
  Widget _buildTabContent() {
    final isMobile = widget.isMobile;

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
        return widget.isLoadingCharacters
            ? const Center(child: CircularProgressIndicator())
            : widget.charactersErrorMessage != null
                ? Center(
                    child: Text(widget.charactersErrorMessage!, style: const TextStyle(color: Colors.red)),
                  )
                : widget.episodeCharacters.isEmpty
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
                          crossAxisCount: isMobile ? 2 : 4, 
                          crossAxisSpacing: isMobile ? 16.0 : 20.0,
                          mainAxisSpacing: isMobile ? 16.0 : 20.0,
                          childAspectRatio: 0.8, 
                        ),
                        itemCount: widget.episodeCharacters.length,
                        itemBuilder: (context, index) {
                          final character = widget.episodeCharacters[index];
                          return CastMemberCard(character: character);
                        },
                      );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
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
        _buildTabContent(),
      ],
    );
  }
}