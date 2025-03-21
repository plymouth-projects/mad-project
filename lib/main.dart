import 'package:flutter/material.dart';
import 'views/home/home_screen.dart'; // Updated import path
import 'config/app_colors.dart'; // Updated import path

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindWork App',
      home: const HomeScreen(),  // Use the HomeScreen from navbar.dart
      theme: ThemeData(
        fontFamily: 'Lato', // Set Lato as the default font for the entire app
        primarySwatch: AppColors.primaryBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navyBlue,
          foregroundColor: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.primaryBlue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryBlue)
            .copyWith(secondary: AppColors.accentBlue),
        // Set default text color to white for the entire app
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        // Also set primary text theme to white
        primaryTextTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}