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
  late Timer _autoplayTimer;
  late List<Map<String, dynamic>> freelancers;
  final FreelancerService _freelancerService = FreelancerService();

  @override
  void initState() {
    super.initState();
    freelancers = _freelancerService.getFreelancers();
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
