import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../widgets/home/hero_section.dart';
import '../../widgets/top_services.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/job_opportunities.dart';
import '../../widgets/home/freelancers_section.dart';
import '../../widgets/home/contact_us.dart';
import '../../widgets/navbar.dart';
import '../../widgets/home/business_section.dart';
import '../../widgets/home/footer.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithDrawer(currentRoute: AppRoutes.home),
      drawer: const AppNavDrawer(currentRoute: AppRoutes.home),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            const TopServices(),
            const CategorySection(),
            const JobCarousel(),
            const FreelancerCarousel(),
            const CompaniesSection(),
            const ContactUs(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
