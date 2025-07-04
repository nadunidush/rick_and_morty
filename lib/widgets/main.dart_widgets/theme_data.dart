import 'package:flutter/material.dart';

ThemeData themeDataMain = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: const Color(0xFF1A202C),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A202C),
    elevation: 0, // No shadow
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Inter',
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Inter',
    ),
    headlineMedium: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Inter',
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: Colors.white70,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: Colors.white54,
      fontFamily: 'Inter',
    ),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF2D3748),
    elevation: 8.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2D3748),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.white54, fontFamily: 'Inter'),
    prefixIconColor: Colors.white54,
    suffixIconColor: Colors.white54,
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
);
