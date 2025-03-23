import 'package:flutter/material.dart';
import 'dart:async';
import '../config/app_colors.dart';

class TopServices extends StatefulWidget {
  const TopServices({super.key});

  @override
  State<TopServices> createState() => _TopServicesState();
}

class _TopServicesState extends State<TopServices> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _autoplayTimer;
  
  final List<Map<String, String>> services = [
    {
      'image': 'assets/images/job_posting.png',
      'title': 'Post a Job',
      'description': 'Quickly create and share job postings to find the right workers with ease. Post listings, connect with qualified candidates, and hire the perfect fit—all in just a few clicks!',
    },
    {
      'image': 'assets/images/hire_worker.png',
      'title': 'Hire Worker',
      'description': 'Find the perfect worker for your project from a list of verified professionals. Secure payments ensure transparency and trust, making hiring seamless and worry-free through our platform.',
    },
    {
      'image': 'assets/images/apply_job.png',
      'title': 'Apply for Jobs',
      'description': 'Discover jobs tailored to your skills, location, and preferences. Explore listings, apply with confidence, and land opportunities that align with your schedule—making job hunting easier and more rewarding!',
    },
    {
      'image': 'assets/images/post_proficiency.png',
      'title': 'Post Your Proficiency',
      'description': 'Highlight your expertise and stand out to potential employers! Create a compelling profile showcasing your skills, experience, and achievements, increasing your chances of getting hired for the perfect opportunity.',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize with a large number to allow "infinite" scrolling
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.95,  // Changed from 0.85 to 0.95
    );
    
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round() % services.length;
      });
    });
    
    _startAutoplay();
  }
  
  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _pageController.page!.round() + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  
  void _stopAutoplay() {
    if (_autoplayTimer.isActive) {
      _autoplayTimer.cancel();
    }
  }

  @override
  void dispose() {
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
            'TOP FEATURED SERVICE',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 450, // Increased from 300 to 350
          child: PageView.builder(
            controller: _pageController,
            itemCount: null,
            itemBuilder: (context, index) {
              final serviceIndex = index % services.length;
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
                    child: _buildServiceCard(
                      services[serviceIndex]['image']!,
                      services[serviceIndex]['title']!,
                      services[serviceIndex]['description']!,
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Page indicator
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              services.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? AppColors.accentBlue 
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String image, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: AppColors.navyBlue,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 210, // Reduced from 150
              width: double.infinity,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16.0, bottom: 12.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
