import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart'; 

class EpisodeHeaderSection extends StatelessWidget {
  final Episode episode;
  final bool isMobile;
  final double horizontalPadding;
  final bool isInWatchlist;
  final VoidCallback onToggleWatchlist;

  const EpisodeHeaderSection({
    super.key,
    required this.episode,
    required this.isMobile,
    required this.horizontalPadding,
    required this.isInWatchlist,
    required this.onToggleWatchlist,
  });


  Widget _buildMetadataItem(BuildContext context, String text, IconData icon, {Color? color}) {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: isMobile ? 200 : 250, 
          width: double.infinity,
          child: Image.network(
            episode.imageUrl ?? 'https://placehold.co/1200x250/2D3748/FFFFFF?text=Episode+Banner',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[700],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 80)),
              );
            },
          ),
        ),
        Positioned(
          top: isMobile ? 16 : 32, 
          left: isMobile ? 16 : 32,
          right: isMobile ? 16 : 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); 
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
                onTap: onToggleWatchlist, 
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isInWatchlist ? Icons.bookmark : Icons.bookmark_border, 
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: isMobile ? 150 : 200, 
          left: horizontalPadding,
          right: horizontalPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.white, width: 2.0), 
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
                    episode.imageUrl ?? 'https://placehold.co/100x150/2D3748/FFFFFF?text=No+Image',
                    width: isMobile ? 80 : 100, 
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
              SizedBox(width: isMobile ? 12.0 : 20.0), 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      episode.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: isMobile ? 22 : 28, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 4.0 : 8.0), 
                    Wrap(
                      spacing: isMobile ? 8.0 : 16.0, 
                      runSpacing: isMobile ? 4.0 : 8.0,
                      children: [
                        _buildMetadataItem(context, '2021', Icons.calendar_today), 
                        _buildMetadataItem(context, '140 Minutes', Icons.timer), 
                        _buildMetadataItem(context, episode.episode, Icons.movie_filter),
                        _buildMetadataItem(
                          context,
                          episode.userRating > 0 ? episode.userRating.toStringAsFixed(1) : 'N/A',
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
    );
  }
}