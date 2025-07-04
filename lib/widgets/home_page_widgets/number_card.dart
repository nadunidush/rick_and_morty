import 'package:flutter/material.dart';

class NumberedContentCard extends StatelessWidget {
  final String imageUrl;
  final int number;

  const NumberedContentCard({
    super.key,
    required this.imageUrl,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to detail screen based on content type
        print('Tapped on card with number $number');
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Ensures image respects rounded corners
        child: Container(
          width: 150, // Fixed width for the card (adjust as needed)
          height: 200, // Fixed height for the card (adjust as needed)
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
              // Image
              Positioned.fill(
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
              // Number Overlay (bottom left)
              Positioned(
                bottom: -10, // Adjust position to match Figma
                left: -5, // Adjust position to match Figma
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 100, // Large font size for the number
                    fontWeight: FontWeight.w900, // Extra bold
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
            ],
          ),
        ),
      ),
    );
  }
}