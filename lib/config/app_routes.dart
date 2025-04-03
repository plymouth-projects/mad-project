import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';
import '../views/auth/signin.dart';
import '../views/auth/signup.dart';
import '../views/job_hub/job_hub.dart';
import '../views/job_details/job_details.dart';
import '../views/workforce_hub/workforce_hub.dart';
import '../views/freelancer_details/freelancer_details.dart';
import '../views/business_hub/business_hub.dart';
import '../views/business_details/business_details.dart';
import '../views/dashboard/user_dashboard.dart'; // Add import for dashboard
// Import other screens as they are implemented

class AppRoutes {
  static const String home = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String jobHub = '/jobHub';
  static const String jobDetails = '/jobDetails';
  static const String workforceHub = '/workforceHub';
  static const String businessHub = '/businessHub';
  static const String freelancerDetails = '/freelancerDetails';
  static const String businessDetails = '/businessDetails';
  static const String dashboard = '/dashboard'; // Add dashboard route
  // Define other route names as needed
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      jobHub: (context) => const JobHubScreen(),
      jobDetails: (context) => const JobDetailsScreen(),
      workforceHub: (context) => const WorkforceHubScreen(),
      businessHub: (context) => const BusinessHub(),
      freelancerDetails: (context) => const FreelancerDetailsScreen(),
      businessDetails: (context) {
        final company = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BusinessDetails(company: company);
      },
      dashboard: (context) => const UserDashboard(), // Add dashboard route builder
      // Add other routes as they are implemented
    };
  }
}
