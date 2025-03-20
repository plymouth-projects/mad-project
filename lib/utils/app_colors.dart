import 'package:flutter/material.dart';

class AppColors {
  // Primary dark blue color swatch
  static const MaterialColor primaryBlue = MaterialColor(
    0xFF163950, // This is your primary color (scaffoldBackgroundColor)
    <int, Color>{
      50: Color(0xFFE3E7EB),
      100: Color(0xFFB8C2CD),
      200: Color(0xFF899AAC),
      300: Color(0xFF5A728A),
      400: Color(0xFF375371),
      500: Color(0xFF163950), // Primary color
      600: Color(0xFF133349),
      700: Color(0xFF102C40),
      800: Color(0xFF0C2438),
      900: Color(0xFF061729),
    },
  );

  // Deep navy blue for app bar
  static const MaterialColor navyBlue = MaterialColor(
    0xFF000414, // This is your appBar color
    <int, Color>{
      50: Color(0xFFE0E0E4),
      100: Color(0xFFB3B3BC),
      200: Color(0xFF808090),
      300: Color(0xFF4D4D64),
      400: Color(0xFF262642),
      500: Color(0xFF000414), // Navy Blue color
      600: Color(0xFF000312),
      700: Color(0xFF00030F),
      800: Color(0xFF00020C),
      900: Color(0xFF000106),
    },
  );

  // Accent blue color for highlights (like the FINDWORK text)
  static const MaterialColor accentBlue = MaterialColor(
    0xFF66B6C9, // Teal blue
    <int, Color>{
      50: Color(0xFFEDF7F9),
      100: Color(0xFFD1EAF0),
      200: Color(0xFFB3DCE6),
      300: Color(0xFF94CEDC),
      400: Color(0xFF7DC2D4),
      500: Color(0xFF66B6C9), // Teal blue (primary)
      600: Color(0xFF5EAFC0),
      700: Color(0xFF53A6B6),
      800: Color(0xFF499EAC),
      900: Color(0xFF388E9C),
    },
  );

  static const MaterialColor tealDark = MaterialColor(
    0xFF1c829b, // Teal Dark
    <int, Color>{
      50: Color(0xFFE3F1F4),
      100: Color(0xFFB9DCE4),
      200: Color(0xFF8BC5D3),
      300: Color(0xFF5CADC1),
      400: Color(0xFF3A9BB3),
      500: Color(0xFF1c829b), // Teal Dark (primary)
      600: Color(0xFF197A93),
      700: Color(0xFF156F89),
      800: Color(0xFF12657F),
      900: Color(0xFF0A516D),
    },
  );

  // Standard white
  static const Color white = Colors.white;
}
