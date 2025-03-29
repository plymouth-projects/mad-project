import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainHeading(),
          const SizedBox(height: 24),
          _buildDescriptionText(),
          const SizedBox(height: 40),
          _buildJoinButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMainHeading() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 32,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
          color: Colors.white, // Default color for all text
        ),
        children: [
          TextSpan(
            text: 'WELCOME TO ',
            style: TextStyle(
              fontSize: 42, // Blue color only for WELCOME TO
            ),
          ),
          TextSpan(
            text: 'FINDWORK',
            style: TextStyle(
              fontSize: 42,
              color: AppColors.accentBlue, // Blue color only for FINDWORK
            ),
          ),
          TextSpan(text: '\n'), // Adds a new line
          TextSpan(text: 'YOUR GATEWAY TO OPPORTUNITY'),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 17,
          height: 1.6,
          letterSpacing: 1.2, // Default color for the text
        ),
        children: [
          TextSpan(
            text: 'FindWork connects employees, employers, freelancers, and contractors '
                'to discover opportunities, showcase talents and build success with our '
                'platform. We designed this to amplify hiring and working.\n\n',
          ),
          TextSpan(
            text: 'Find. Connect. and Thrive with ',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Blue color for the text
            ),
          ),
          TextSpan(
            text: 'US',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accentBlue, // Blue color for the text
            ),
          ),
          TextSpan(
            text: ' !',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/signup');
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        backgroundColor: AppColors.tealDark, // Blue color for the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Reduced roundness (smaller value = less round)
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'JOIN US NOW',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
            SizedBox(width: 15), // Add some space between text and icon
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 20, // Increase the size of the icon to make it wider
          ),
        ],
      ),
    );
  }
}