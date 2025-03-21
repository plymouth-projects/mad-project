import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';
// Import other screens as they are implemented

class AppRoutes {
  static const String home = '/';
  // Define other route names as needed
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      // Add other routes as they are implemented
    };
  }
}
