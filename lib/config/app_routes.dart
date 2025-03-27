import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';
import '../views/auth/signin.dart';
import '../views/auth/signup.dart';
// Import other screens as they are implemented

class AppRoutes {
  static const String home = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  // Define other route names as needed
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      // Add other routes as they are implemented
    };
  }
}
