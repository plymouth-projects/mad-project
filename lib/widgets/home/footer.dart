import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import '../../config/navigation.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: AppColors.navyBlue,
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 30),
          _buildNavLinks(context),
          const SizedBox(height: 30),
          _buildDivider(),
          const SizedBox(height: 30),
          _buildSocialMediaLinks(),
          const SizedBox(height: 30),
          _buildCopyright(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SvgPicture.asset(
      'assets/images/findwork.svg',
      height: 25,
    );
  }

  Widget _buildNavLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 30.0,
        runSpacing: 15.0,
        children: [
          _buildNavLink('Home', AppRoutes.home),
          _buildNavLink('Job Hub', AppRoutes.jobHub),
          _buildNavLink('Workforce Hub', AppRoutes.workforceHub),
          _buildNavLink('Business Hub', AppRoutes.businessHub),
          _buildNavLink('About Us', '/about'),
          _buildNavLink('Contact', '/contact'),
          _buildNavLink('Privacy Policy', '/privacy'),
          _buildNavLink('Terms of Service', '/terms'),
        ],
      ),
    );
  }

  Widget _buildNavLink(String title, String route) {
    return InkWell(
      onTap: () {
        NavigationService.navigateTo(route);
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: Colors.white24,
        thickness: 1,
      ),
    );
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.facebook, () {}),
        _buildSocialIcon(Icons.alternate_email, () {}), // Using @ symbol for Twitter/X
        _buildSocialIcon(Icons.business_center, () {}), // Using business icon for LinkedIn
        _buildSocialIcon(Icons.photo_camera, () {}), // Using camera icon for Instagram
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(8),
         
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return const Column(
      children: [
        Text(
          '© 2024 FindWork. All rights reserved.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your gateway to opportunity',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
