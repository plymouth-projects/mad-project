import 'dart:async';
import 'package:flutter/material.dart';
import '../carousel_indicator.dart';
import '../freelancer_card.dart';
import '../../services/freelancer_service.dart';
import '../../config/app_routes.dart';

class FreelancerCarousel extends StatefulWidget {
  const FreelancerCarousel({super.key});

  @override
  State<FreelancerCarousel> createState() => _FreelancerCarouselState();
}

class _FreelancerCarouselState extends State<FreelancerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoplayTimer;
  List<Map<String, dynamic>> freelancers = [];
  final FreelancerService _freelancerService = FreelancerService();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.92,
    );
    _loadFreelancers();
  }

  Future<void> _loadFreelancers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final featuredFreelancers = await _freelancerService.getFeaturedFreelancers();
      
      // Process the freelancers data to ensure proper type conversion
      final processedFreelancers = featuredFreelancers.map((freelancer) {
        // Make a copy of the freelancer map
        final Map<String, dynamic> processedData = Map<String, dynamic>.from(freelancer);
        
        // Ensure any lists that should be List<String> are properly converted
        // Check for common fields that might be lists
        if (processedData.containsKey('skills') && processedData['skills'] is List) {
          processedData['skills'] = (processedData['skills'] as List).map((item) => item.toString()).toList();
        }
        
        if (processedData.containsKey('languages') && processedData['languages'] is List) {
          processedData['languages'] = (processedData['languages'] as List).map((item) => item.toString()).toList();
        }
        
        // Add other list fields that might need conversion here if needed
        
        return processedData;
      }).toList();
      
      if (mounted) {
        setState(() {
          freelancers = processedFreelancers;
          _isLoading = false;
        });
        
        if (freelancers.isNotEmpty) {
          _pageController = PageController(
            viewportFraction: 0.92,
            initialPage: freelancers.length * 1000,
          );
          _startAutoplay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load freelancers: $e';
        });
      }
    }
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && freelancers.isNotEmpty) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
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
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 450,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return SizedBox(
        height: 450,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFreelancers,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (freelancers.isEmpty) {
      return const SizedBox(
        height: 450,
        child: Center(
          child: Text(
            'No featured freelancers found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 450,
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

  Widget _buildFreelancerCard(Map<String, dynamic> freelancer, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double scale = 1.0;
        if (_pageController.position.haveDimensions) {
          double pageOffset = (_pageController.page ?? 0) - index;
          scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.5, 1.0);
        }
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.freelancerDetails,
              arguments: freelancer,
            );
          },
          child: FreelancerCard(
            freelancer: freelancer,
            scale: scale,
          ),
        );
      },
    );
  }
}
