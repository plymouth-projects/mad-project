import 'package:flutter/material.dart';
import 'package:mad_project/utils/app_colors.dart';

class TopServices extends StatelessWidget {
  const TopServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'TOP FEATURED SERVICES',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5, // Width to height ratio of grid items
            children: [
              _buildServiceCard('Plumbing', Icons.plumbing),
              _buildServiceCard('Electricians', Icons.electrical_services),
              _buildServiceCard('Cleaning', Icons.cleaning_services),
              _buildServiceCard('Baby Care', Icons.child_care),
              _buildServiceCard('Security', Icons.security),
              _buildServiceCard('IT Support', Icons.computer),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, IconData icon) {
    return Card(
      color: AppColors.tealDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 45, color: AppColors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white, 
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
