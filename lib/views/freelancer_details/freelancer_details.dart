import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';

class FreelancerDetailsScreen extends StatelessWidget {
  const FreelancerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> freelancer = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.workforceHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.workforceHub),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(freelancer),
              const SizedBox(height: 24),
              _buildProfileSection(freelancer),
              const SizedBox(height: 24),
              _buildSkillsSection(freelancer),
              const SizedBox(height: 24),
              _buildExperienceSection(freelancer),
              const SizedBox(height: 24),
              _buildHireButton(context, freelancer),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> freelancer) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'FREELANCER DETAILS',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    )
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> freelancer) {
    final name = freelancer['name'] ?? 'Unknown';
    final title = freelancer['title'] ?? 'Title not specified';
    final rating = freelancer['rating']?.toString() ?? '0';
    final availability = freelancer['availability'] ?? 'Not specified';
    final description = freelancer['description'] ?? 'No description available';
    final profileImage = freelancer['profileImage'] ?? 'assets/images/default_profile.png';

    return Card(
      color: const Color(0xFF1A5C83),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profileImage),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.star,
                            rating,
                            AppColors.tealDark,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.access_time,
                            availability,
                            Colors.blue.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(Map<String, dynamic> freelancer) {
    final List<String> skills = (freelancer['skills'] as List<dynamic>?)?.cast<String>() ?? [];
    
    return Card(
      color: const Color(0xFF1A5C83),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => Chip(
                backgroundColor: AppColors.tealDark,
                label: Text(
                  skill,
                  style: const TextStyle(color: Colors.white),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection(Map<String, dynamic> freelancer) {
    final level = freelancer['level'] ?? 'Beginner';
    final yearsOfExperience = freelancer['yearsOfExperience']?.toString() ?? '0';
    final hourlyRate = freelancer['hourlyRate']?.toString() ?? '0';

    return Card(
      color: const Color(0xFF1A5C83),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experience & Expertise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildExperienceItem(
              'Level',
              level,
              Icons.trending_up,
            ),
            const Divider(color: Colors.white24),
            _buildExperienceItem(
              'Experience',
              '$yearsOfExperience years',
              Icons.work,
            ),
            const Divider(color: Colors.white24),
            _buildExperienceItem(
              'Hourly Rate',
              '\$$hourlyRate/hr',
              Icons.attach_money,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHireButton(BuildContext context, Map<String, dynamic> freelancer) {
    final name = freelancer['name'] ?? 'Unknown';

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF0E3A5D),
                title: const Text(
                  'Confirm Hiring',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  'Are you sure you want to hire $name?',
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You\'ve hired $name!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealDark,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tealDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'HIRE NOW',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
