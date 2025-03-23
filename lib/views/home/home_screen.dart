import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mad_project/widgets/job_opportunities.dart';
import '../../config/app_colors.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/top_services.dart';
import '../../widgets/category_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/findwork.svg',
          height: 19,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
              iconSize: 30,
              onPressed: () {
                // Handle search icon tap
              },
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            const TopServices(),
            const CategorySection(),
            const JobCarousel(),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.navyBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer header with logo
            Padding(
              padding: const EdgeInsets.only(top: 65.0, left: 16.0, bottom: 16.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/findwork.svg',
                    height: 19,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            
            // Menu items
            _buildMenuItem('Home', Icons.home_outlined, isSelected: true),
            _buildMenuItem('Job Hub', Icons.work_outline),
            _buildMenuItem('WorkForce Hub', Icons.people_outline),
            _buildMenuItem('Business Hub', Icons.business_outlined),
            _buildMenuItem('About Us', Icons.info_outline),
            
            const Spacer(), // Pushes the bottom items to the bottom of the drawer
            
            // Bottom menu items
            const Divider(color: Colors.white24, height: 1),
            _buildMenuItem('Settings', Icons.settings_outlined),
            _buildMenuItem('Log In / Sign Up', Icons.login_outlined),
            
            // Version info at bottom
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, {bool isSelected = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accentBlue : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.accentBlue : Colors.white,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        // Handle navigation here
        // For demonstration, we're just closing the drawer
        // Navigator.pop(context);
        
        // In a real app, you would navigate to the respective screen:
        // Navigator.pushNamed(context, '/job-hub');
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    );
  }
}