import 'dart:async';
import 'package:flutter/material.dart';
import '../config/app_colors.dart'; // Updated import path

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _autoplayTimer;
  
  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.9,
    );
    
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round() % categories.length;
      });
    });
    
    _startAutoplay();
  }
  
  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _pageController.page!.round() + 1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  
  void _stopAutoplay() {
    _autoplayTimer.cancel();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _stopAutoplay();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'FEATURED CATEGORIES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        SizedBox(
          height: 310, // Increased height from 200 to 220 to accommodate content
          child: PageView.builder(
            controller: _pageController,
            itemCount: null, // null for infinite scrolling
            itemBuilder: (context, index) {
              final actualIndex = index % categories.length;
              final category = categories[actualIndex];
              
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                    value = (1 - (value * 0.3).clamp(0.0, 1.0));
                  }
                  return Transform.scale(
                    scale: Curves.easeInOut.transform(value),
                    child: _buildCategoryCard(
                      category['title']!,
                      category['icon']!,
                      category['jobs']!,
                      category['services']!,
                      index == _pageController.page?.round(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        _buildPageIndicator(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        categories.length, // Keep indicator count the same as actual categories
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage % categories.length == index ? 24 : 8, // Use modulo for proper highlighting
          decoration: BoxDecoration(
            color: _currentPage % categories.length == index ? AppColors.accentBlue : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, String jobs, List<String> services, bool isActive) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(icon, size: 28, color: AppColors.navyBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18, // Smaller font
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$jobs Jobs Available',  // Shorter text
                            style: const TextStyle(fontSize: 13, color: AppColors.navyBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                LimitedBox(
                  maxHeight: 150, // Set maximum height for services section
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Don't scroll this part
                    padding: EdgeInsets.zero,
                    children: services.map((service) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0, left: 25.0), // Reduced padding
                        child: Text(
                          '• $service', 
                          style: const TextStyle(color: AppColors.navyBlue, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ).toList(),
                  ),
                ),
                
                // Add space to ensure room for the positioned button
                const SizedBox(height: 50),
              ],
            ),
            
            // Fixed position button
            Positioned(
              left: 25,
              bottom: 5,
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                  ),
                  child: const Text(
                    'VIEW MORE', 
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample data for categories
final List<Map<String, dynamic>> categories = [
  {
    'title': 'Home Maintenance',
    'icon': Icons.home_repair_service,
    'jobs': '22',
    'services': ['Cleaning & Household Assistance', 'Plumbing & Water Systems', 'Electrical & Wiring Services', 'Carpentry & Furniture Work', 'Painting & Wall Finishing', 'Appliance Repair & Installation'],
  },
  {
    'title': 'Personal Care',
    'icon': Icons.person,
    'jobs': '18',
    'services': ['Babysitter', 'Daycare Assistant', 'Elderly Care', 'Home Health Aide', 'Compainion Care Assistant', 'Patient Care Assistant'],
  },
  {
    'title': 'Construction and Renovations',
    'icon': Icons.build,
    'jobs': '11',
    'services': ['Masonry & Building Construction', 'Carpentry & Woodwork', 'Plumbing & Water Systems', 'Electrical & Wiring Work', 'Painting & Finishing', 'General Construction Labor'],
  },
  {
    'title': 'Transport and Security',
    'icon': Icons.directions_car,
    'jobs': '33',
    'services': ['Security Guards', 'Drivers', 'CCTV Operators', 'Bodyguards', 'Security Alarm Installers'],
  },
];