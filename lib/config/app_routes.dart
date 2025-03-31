import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';
import '../views/auth/signin.dart';
import '../views/auth/signup.dart';
import '../views/job_hub/job_hub.dart';
// Import other screens as they are implemented

class AppRoutes {
  static const String home = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String jobHub = '/jobHub';
  // Define other route names as needed
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      jobHub: (context) => const JobHubScreen(),
      // Add other routes as they are implemented
    };
  }
}
