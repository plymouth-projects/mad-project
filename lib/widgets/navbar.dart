import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/navigation.dart';
import '../services/auth_service.dart'; // Add import for AuthService

class AppNavDrawer extends StatefulWidget {
  final String currentRoute;

  const AppNavDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  State<AppNavDrawer> createState() => _AppNavDrawerState();
}

class _AppNavDrawerState extends State<AppNavDrawer> {
  @override
  Widget build(BuildContext context) {
    final bool isSignedIn = AuthService.isUserSignedIn();

    return Drawer(
      child: Container(
        color: AppColors.navyBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 65.0, left: 16.0, bottom: 16.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/findwork.svg',
                    height: 19,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),

            // Menu items with navigation
            _buildMenuItem('Home', Icons.home_outlined, AppRoutes.home),
            _buildMenuItem('Job Hub', Icons.work_outline, AppRoutes.jobHub),
            _buildMenuItem('WorkForce Hub', Icons.people_outline, AppRoutes.workforceHub),
            _buildMenuItem('Business Hub', Icons.business_outlined, AppRoutes.businessHub),
            _buildMenuItem('About Us', Icons.info_outline, '/about'),

            const Spacer(),

            const Divider(color: Colors.white24, height: 1),
            _buildMenuItem('Settings', Icons.settings_outlined, '/settings'),

            // Conditionally show Login or Logout based on authentication status
            isSignedIn
                ? _buildLogoutMenuItem()
                : _buildMenuItem('Log In / Sign Up', Icons.login_outlined, AppRoutes.signin),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutMenuItem() {
    return ListTile(
      leading: const Icon(
        Icons.logout_outlined,
        color: Colors.white,
        size: 24,
      ),
      title: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      onTap: () async {
        Navigator.pop(context); // Close the drawer first
        await AuthService().signOut();
        NavigationService.navigateTo(AppRoutes.home);
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, String routeName) {
    final bool isSelected = widget.currentRoute == routeName;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accentBlue : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.accentBlue : Colors.white,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer first
        if (widget.currentRoute != routeName) {
          NavigationService.navigateTo(routeName);
        }
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    );
  }
}

class AppBarWithDrawer extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const AppBarWithDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
        'assets/images/findwork.svg',
        height: 19,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            iconSize: 30,
            onPressed: () {
              // Check if user is signed in and navigate accordingly
              if (AuthService.isUserSignedIn()) {
                NavigationService.navigateTo(AppRoutes.dashboard);
              } else {
                NavigationService.navigateTo(AppRoutes.signin);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
