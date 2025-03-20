import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainHeading(),
          const SizedBox(height: 24),
          _buildDescriptionText(),
          const SizedBox(height: 40),
          _buildJoinButton(),
          const SizedBox(height: 40),
          _buildFooterText(),
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
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: Colors.white, // Default color for all text
        ),
        children: [
          TextSpan(text: 'WELCOME TO '),
          TextSpan(
            text: 'FINDWORK',
            style: TextStyle(
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

  Widget _buildJoinButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        'JOIN US NOW',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Text(
      'Every connection built on',
      style: TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    );
  }
}