import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final String imageUrl;

  const ContentCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to detail screen based on content type
        print('Tapped on content card');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 50,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}