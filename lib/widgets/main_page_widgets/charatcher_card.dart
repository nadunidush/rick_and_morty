import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/pages/character_details_page.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailScreen(characterId: character.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Character Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character.image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[700],
                      child: const Icon(Icons.person_off, color: Colors.white54, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              // Character Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: character.status == 'Alive' ? Colors.green : (character.status == 'Dead' ? Colors.red : Colors.grey),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '${character.status} - ${character.species}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Last known location:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                    Text(
                      character.location.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
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