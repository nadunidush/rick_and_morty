import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/screen_sizes.dart';

class RatingDialog extends StatefulWidget {
  final double initialRating;

  const RatingDialog({super.key, this.initialRating = 0.0});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);
    final isMobile = screenType == ScreenType.mobile;

    return Dialog(
      backgroundColor: Colors.transparent, 
      child: Center(
        child: Container(
          width: isMobile ? MediaQuery.of(context).size.width * 0.8 : 400, 
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3748), 
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rate this episode',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); 
                    },
                    child: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Text(
                _currentRating.toStringAsFixed(1), 
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48, color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              Slider(
                value: _currentRating,
                min: 0.0,
                max: 10.0,
                divisions: 100,
                onChanged: (newValue) {
                  setState(() {
                    _currentRating = newValue;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _currentRating); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF), 
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
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