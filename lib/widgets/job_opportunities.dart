import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'carousel_indicator.dart';

class JobCarousel extends StatefulWidget {
  const JobCarousel({super.key});

  @override
  State<JobCarousel> createState() => _JobCarouselState();
}

class _JobCarouselState extends State<JobCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _autoplayTimer;
  final List<Map<String, String>> jobs = [
    {
      'image': 'assets/images/electrician.png',
      'title': 'JOB TITLE',
      'company': 'DSN Constructions (Pvt) Ltd',
      'location': 'No: 123, Colombo Road, Colombo.',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'salary': 'Rs. 35,000/Month',
      'employement_type': 'Full-time',
      'deadline': '02.04.2025',
    },
    
    {
      'image': 'assets/images/electrician.png',
      'title': 'Software Engineer',
      'company': 'ABC Tech Solutions',
      'location': 'No: 456, Kandy Road, Sri Lanka',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'salary': 'Rs. 100,000/Month',
      'employement_type': 'Full-time',
      'deadline': '02.04.2025',
    },
    {
      'image': 'assets/images/electrician.png',
      'title': 'Marketing Manager',
      'company': 'XYZ Marketing',
      'location': 'Galle Road, Colombo',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'salary': 'Rs. 75,000/Month',
      'employement_type': 'Full-time',
      'deadline': '02.04.2025',
    },
    {
      'image': 'assets/images/electrician.png',
      'title': 'Marketing Manager',
      'company': 'XYZ Marketing',
      'location': 'Galle Road, Colombo',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'salary': 'Rs. 75,000/Month',
      'employement_type': 'Full-time',
      'deadline': '02.04.2025',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.92, // Increased from 0.8 to show more of each card
      initialPage: jobs.length * 1000, // Start at a large multiple of jobs.length
    );
    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        // Simply move to next page without resetting - the PageView.builder will handle looping
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

  // Method to calculate days left until deadline
  String calculateDaysLeft(String? deadlineStr) {
    // Handle null case
    if (deadlineStr == null) return "No deadline";
    
    try {
      // Parse deadline (assuming format is DD.MM.YYYY)
      final parts = deadlineStr.split('.');
      if (parts.length != 3) return "Invalid date";
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final deadline = DateTime(year, month, day);
      final today = DateTime.now();
      
      // Calculate difference in days
      final difference = deadline.difference(today).inDays;
      
      if (difference < 0) {
        return "Deadline passed";
      } else if (difference == 0) {
        return "Last day to apply!";
      } else if (difference == 1) {
        return "1 day left";
      } else {
        return "$difference days left";
      }
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'LATEST JOB OPPORTUNITIES',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 320,
          width: MediaQuery.of(context).size.width, // Use full screen width for container
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page % jobs.length;
              });
            },
            itemBuilder: (context, index) {
              // Use modulo to loop through the job items
              final jobIndex = index % jobs.length;
              return _buildJobCard(jobs[jobIndex], index);
            },
          ),
        ),
        const SizedBox(height: 15),
        CarouselIndicator(
          itemCount: jobs.length,
          currentPage: _currentPage,
        ),
      ],
    );
  }

  Widget _buildJobCard(Map<String, String> job, int index) {
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
              child: Row(
                children: [
                  // Left column - Image (with fixed width)
                  SizedBox(
                    width: 145,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.asset(
                        job['image']!,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                  // Right column - Text content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
                        children: [
                          // Top content area
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                              
                              // Add employment type 
                              Text(
                                job['employement_type'] ?? "Not specified",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              
                              const SizedBox(height: 5),
                              Text(
                                job['company']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              Text(
                                job['location']!,
                                style: const TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                job['description']!,
                                maxLines: 4, // Reduced to fit better
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                job['salary'] ?? "Salary not specified",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              
                              // Add null safety to deadline calculation
                              Text(
                                calculateDaysLeft(job['deadline']),
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: calculateDaysLeft(job['deadline']) == "Deadline passed" 
                                      ? Colors.red 
                                      : AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          // Button at bottom with fixed spacing
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              width: 100, // Reduced width for a smaller button
                              margin: const EdgeInsets.only(right: 50),
                              child: ElevatedButton(
                                onPressed: calculateDaysLeft(job['deadline']) == "Deadline passed" 
                                    ? null
                                    : () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tealDark,
                                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12), // Reduced padding
                                  minimumSize: const Size(100, 30), // Smaller minimum size
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Apply Now',
                                  style: TextStyle(
                                    fontSize: 14, // Smaller font size
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
