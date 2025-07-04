import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';

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
          width: 100,
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