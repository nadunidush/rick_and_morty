import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/pages/character_details_page.dart';

class CharacterHorizontalCard extends StatelessWidget {
  final Character character;
  final int index; // For the number overlay

  const CharacterHorizontalCard({super.key, required this.character, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to character detail if needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(characterId: character.id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Ensures image respects rounded corners
        child: Container(
          width: 150, // Fixed width for the card
          height: 200, // Fixed height for the card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              // Character Image
              Positioned.fill(
                child: Image.network(
                  character.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.person_off, color: Colors.white54, size: 50),
                    );
                  },
                ),
              ),
              // Number Overlay (bottom left)
              Positioned(
                bottom: 8,
                left: 8,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              // Character Name (top left, semi-transparent background)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}