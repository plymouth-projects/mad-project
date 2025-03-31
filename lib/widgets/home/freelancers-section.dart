import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import '../carousel_indicator.dart';

class FreelancerCarousel extends StatefulWidget {
  const FreelancerCarousel({super.key});

  @override
  State<FreelancerCarousel> createState() => _FreelancerCarouselState();
}

class _FreelancerCarouselState extends State<FreelancerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _autoplayTimer;

  final List<Map<String, dynamic>> freelancers = [
    {
      "image": "assets/images/plumber.png",
      "name": "RAYAN FERNANDO",
      "location": "No: 123, Colombo Road, Colombo 07",
      "skills": ["Plumbing", "Electrical", "Painting"],
      "rate": "Rs. 4000/Day",
      "jobsCompleted": "20 Jobs Completed",
      "availability": "Full-Time",
      "level": "Beginner",
    },
    {
      "image": "assets/images/plumber.png",
      "name": "MALITH PERERA",
      "location": "No: 456, Kandy Road, Sri Lanka",
      "skills": ["Carpentry", "Welding", "Masonry"],
      "rate": "Rs. 5000/Day",
      "jobsCompleted": "30 Jobs Completed",
      "availability": "Part-Time",
      "level": "Intermediate",
    },
    {
      "image": "assets/images/plumber.png",
      "name": "ANJALI FONSEKA",
      "location": "Galle Road, Colombo",
      "skills": ["House Cleaning", "Gardening"],
      "rate": "Rs. 3000/Day",
      "jobsCompleted": "15 Jobs Completed",
      "availability": "Full-Time",
      "level": "Expert",
    },
    {
      "image": "assets/images/plumber.png",
      "name": "ANJALI FONSEKA",
      "location": "Galle Road, Colombo",
      "skills": ["House Cleaning", "Gardening"],
      "rate": "Rs. 3000/Day",
      "jobsCompleted": "15 Jobs Completed",
      "availability": "Full-Time",
      "level": "Verified",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.92,
      initialPage: freelancers.length * 1000,
    );
    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
          child: Text(
            'TOP RATED FREELANCERS',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 450, // Increased from 320 to 400
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page % freelancers.length;
              });
            },
            itemBuilder: (context, index) {
              final freelancerIndex = index % freelancers.length;
              return _buildFreelancerCard(freelancers[freelancerIndex], index);
            },
          ),
        ),
        const SizedBox(height: 15),
        CarouselIndicator(
          itemCount: freelancers.length,
          currentPage: _currentPage,
        ),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case "Beginner":
        return Colors.grey.shade400;
      case "Intermediate":
        return AppColors.accentBlue;
      case "Expert":
        return AppColors.primaryBlue;
      case "Verified":
        return Colors.black;
      default:
        return AppColors.accentBlue;
    }
  }
  
  Color _getLevelTextColor(String level) {
    switch (level) {
      case "Beginner":
        return AppColors.primaryBlue;
      case "Intermediate":
        return Colors.white;
      case "Expert":
        return Colors.white;
      case "Verified":
        return Colors.amber;
      default:
        return Colors.white;
    }
  }

  Widget _buildFreelancerCard(Map<String, dynamic> freelancer, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double scale = 1.0;
        if (_pageController.position.haveDimensions) {
          double pageOffset = (_pageController.page ?? 0) - index;
          scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.5, 1.0);
        }
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              color: Colors.white,
              child: Column(
                children: [
                  // Top side - Image with availability badge
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Image.asset(
                            freelancer['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Availability Badge
                      Positioned(
                        top: 10,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            freelancer["availability"]!,
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Bottom side - Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 12.0, top: 12.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      freelancer["name"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: _getLevelColor(freelancer["level"]!),
                                      borderRadius: BorderRadius.circular(8),
                                      border: freelancer["level"] == "Verified" 
                                          ? Border.all(color: Colors.amber, width: 2) 
                                          : null,
                                    ),
                                    child: Text(
                                      freelancer["level"]!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getLevelTextColor(freelancer["level"]!),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                freelancer["location"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 8.0,
                                children: (freelancer["skills"] as List<String>).map((skill) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.primaryBlue),
                                    ),
                                    child: Text(
                                      skill,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                freelancer["rate"]!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                freelancer["jobsCompleted"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tealDark,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 12),
                                  minimumSize: const Size(100, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Hire Now',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
