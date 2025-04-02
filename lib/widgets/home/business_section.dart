import 'dart:async';
import 'package:flutter/material.dart';
import '../carousel_indicator.dart';
import '../business_card.dart';
import '../../services/company_service.dart';
import '../../config/app_routes.dart';
import '../../config/app_colors.dart';

class CompaniesSection extends StatefulWidget {
  const CompaniesSection({super.key});

  @override
  State<CompaniesSection> createState() => _CompaniesSectionState();
}

class _CompaniesSectionState extends State<CompaniesSection> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoplayTimer;
  late List<Map<String, dynamic>> companies;
  final CompanyService _companyService = CompanyService();

  @override
  void initState() {
    super.initState();
    companies = _companyService.getCompanies();
    _initializePageController();
    _startAutoplay();
  }

  void _initializePageController() {
    _pageController = PageController(
      viewportFraction: 0.92,
      initialPage: companies.length * 1000,
    );
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
            'TOP RATED COMPANIES',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        SizedBox(
          height: 550,
          width: MediaQuery.of(context).size.width,
          child: _buildCompanyCarousel(),
        ),
        const SizedBox(height: 15),
        CarouselIndicator(
          itemCount: companies.length,
          currentPage: _currentPage,
        ),
      ],
    );
  }

  Widget _buildCompanyCarousel() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page % companies.length;
        });
      },
      itemBuilder: (context, index) {
        final companyIndex = index % companies.length;
        return _buildCompanyCard(companies[companyIndex], index);
      },
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company, int index) {
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
              AppRoutes.businessDetails,
              arguments: company,
            );
          },
          child: CompanyCard(
            company: company,
            scale: scale,
          ),
        );
      },
    );
  }
}
