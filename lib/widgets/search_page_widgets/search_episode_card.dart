import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/pages/episode_details_page.dart';
import 'package:rick_and_morty/services/tmb_services.dart';
import 'package:rick_and_morty/services/watchlist_service.dart';

class SearchEpisodeCard extends StatelessWidget {
  final Episode episode;
  final RickAndMortyApiService apiService;
  final WatchlistManager watchlistManager;
  final Function(Episode) onRateClicked;

  const SearchEpisodeCard({
    super.key,
    required this.episode,
    required this.apiService,
    required this.watchlistManager,
    required this.onRateClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodeDetailScreen(
              episode: episode,
              apiService: apiService,
              watchlistManager: watchlistManager,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Episode Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  episode.imageUrl ??
                      'https://placehold.co/120x90/2D3748/FFFFFF?text=No+Image', // Placeholder for missing image
                  width: 120,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 90,
                      color: Colors.grey[700],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              // Episode Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.name,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onRateClicked(episode);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                episode.userRating > 0
                                    ? episode.userRating.toStringAsFixed(1)
                                    : 'N/A',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.amber),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.movie_filter,
                          color: Colors.white54,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          episode.episode,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white54,
                          size: 16,
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            episode.airDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),

                        const Icon(
                          Icons.timer,
                          color: Colors.white54,
                          size: 16,
                        ),

                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          '22 minutes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
