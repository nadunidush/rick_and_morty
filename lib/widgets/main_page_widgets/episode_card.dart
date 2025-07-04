import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Episode Image (if available)
            if (episode.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  episode.imageUrl!,
                  width: 120,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 90,
                      color: Colors.grey[700],
                      child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                    );
                  },
                ),
              )
            else
              Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Icon(Icons.tv, color: Colors.white54, size: 40),
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    episode.episode,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Air Date: ${episode.airDate}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}