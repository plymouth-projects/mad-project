import 'package:flutter/material.dart';

class JobCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> jobs;

  const JobCarousel({
    super.key,
    required this.jobs,
  });

  @override
  State<JobCarousel> createState() => _JobCarouselState();
}

class _JobCarouselState extends State<JobCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the page controller safely
    _initializePageController();
  }

  void _initializePageController() {
    _pageController = PageController(
      viewportFraction: 0.85,
      // Safely handle empty job list by defaulting to page 0
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for empty jobs list
    if (widget.jobs.isEmpty) {
      return const Center(
        child: Text(
          'No job opportunities available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                // Safely handle the modulo operation to prevent division by zero
                _currentPage = widget.jobs.isNotEmpty ? index % widget.jobs.length : 0;
              });
            },
            itemBuilder: (context, index) {
              // Safely handle the modulo operation to prevent division by zero
              final jobIndex = widget.jobs.isNotEmpty ? index % widget.jobs.length : 0;
              
              // Safety check to prevent out of bounds access
              if (widget.jobs.isEmpty || jobIndex >= widget.jobs.length) {
                return const SizedBox.shrink();
              }
              
              final job = widget.jobs[jobIndex];
              return _buildJobCard(job);
            },
          ),
        ),
        // Pagination indicators
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.jobs.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    // Implement your job card UI here
    return Card(
      // Card implementation
    );
  }
}
