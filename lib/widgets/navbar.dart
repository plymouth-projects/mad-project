  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:mad_project/utils/app_colors.dart';
  import 'hero-section.dart';
  import 'top-services.dart';
  import 'categories.dart';
   // Import the hero section

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/images/findwork.svg',
            height: 19, // Adjust based on your SVG size
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
              const CategoriesSection(),
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
              Padding(
                padding: const EdgeInsets.only(top:65.0, left: 16.0, bottom: 16.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/findwork.svg',
                      height: 19, // Adjust based on your SVG size
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildMenuItem('Home', Icons.home_outlined),
              _buildMenuItem('Job Hub', Icons.work_outline),
              _buildMenuItem('WorkForce Hub', Icons.people_outline),
              _buildMenuItem('Business Hub', Icons.business_outlined),
              _buildMenuItem('About Us', Icons.info_outline),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 100.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }

    Widget _buildMenuItem(String title, IconData icon) {
      return ListTile(
        leading: Icon(icon, color: AppColors.white),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: AppColors.white),
        ),
        onTap: () {},
      );
    }
  }