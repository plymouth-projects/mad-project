import 'dart:async';
import 'package:flutter/material.dart';
import '../config/app_colors.dart'; // Updated import path

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late Timer _autoplayTimer;
  
  @override
  void initState() {
    super.initState();
    
    // Setup page change listener
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
    
    // Setup autoplay timer
    _startAutoplay();
  }
  
  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < categories.length - 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          categories.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ).then((_) {
          _pageController.jumpToPage(0);
        });
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
          height: 250, // Increased height from 200 to 220 to accommodate content
          child: PageView.builder(
            controller: _pageController,
            itemCount: categories.length + 1, // Add one extra item for smooth looping
            itemBuilder: (context, index) {
              // If we're at the "extra" item at the end, show the first item again
              final actualIndex = index % categories.length;
              final category = categories[actualIndex];
              bool isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: isActive ? 5 : 10),
                child: _buildCategoryCard(
                  category['title']!,
                  category['icon']!,
                  category['jobs']!,
                  category['services']!,
                  isActive,
                ),
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
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage % categories.length == index ? 24 : 8, // Use modulo for proper highlighting
          decoration: BoxDecoration(
            color: _currentPage % categories.length == index ? AppColors.accentBlue : Colors.grey.withOpacity(0.5),
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
      elevation: isActive ? 8 : 4,
      child: Padding(
        padding: const EdgeInsets.only(left:20.0, right: 10.0, top: 20.0, bottom: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: AppColors.navyBlue), // Smaller icon
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
                        '$jobs Jobs',  // Shorter text
                        style: const TextStyle(fontSize: 12, color: AppColors.navyBlue),
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
                children: services.take(3).map((service) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, left: 15.0), // Reduced padding
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
            
            const SizedBox(height: 25), // Push button to bottom
            
            // Button
            Center(
              child: SizedBox(
                height: 30, // Fixed height button
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
    'services': ['Plumbing', 'Electrical Work', 'Carpentry'],
  },
  {
    'title': 'Personal Care',
    'icon': Icons.person,
    'jobs': '18',
    'services': ['House building', 'Commercial projects', 'Renovations'],
  },
  {
    'title': 'Construction and Renovations',
    'icon': Icons.build,
    'jobs': '11',
    'services': ['Hair Care', 'Skincare & Facials', 'Makeup & Beauty'],
  },
  {
    'title': 'Transport and Security',
    'icon': Icons.directions_car,
    'jobs': '33',
    'services': ['Vehicle Rentals', 'CCTV & Surveillance Systems', 'Home & Office Security'],
  },
];