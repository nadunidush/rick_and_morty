import 'package:flutter/material.dart';

Widget buildNavBarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: isActive ? Colors.white : Colors.white54, 
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}