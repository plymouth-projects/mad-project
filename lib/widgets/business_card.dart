import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';

class CompanyCard extends StatelessWidget {
  final Map<String, dynamic> company;
  final double scale;
  final VoidCallback? onViewDetails;

  const CompanyCard({
    super.key,
    required this.company,
    this.scale = 1.0,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Card(
        margin: const EdgeInsets.all(15.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(
            minHeight: 450, // Minimum height to maintain good appearance
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderSection(),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 50, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCompanyInfo(),
                      const SizedBox(height: 5),
                      Flexible(
                        fit: FlexFit.loose,
                        child: _buildCompanyDetails(),
                      ),
                      const SizedBox(height: 10),
                      _buildViewDetailsButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header section with cover image and logo
  Widget _buildHeaderSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildCoverImage(),
        _buildCompanyLogo(),
      ],
    );
  }

  // Cover image widget
  Widget _buildCoverImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: Image.asset(
        company['coverImage'] ?? 'assets/images/default_cover.png',
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 150,
            color: AppColors.primaryBlue.withOpacity(0.1),
            child: Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: AppColors.primaryBlue.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
    );
  }

  // Company logo widget
  Widget _buildCompanyLogo() {
    return Positioned(
      left: 20,
      bottom: -40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            company['logo'] ?? 'assets/images/placeholder.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                child: const Icon(Icons.business, color: AppColors.primaryBlue),
              );
            },
          ),
        ),
      ),
    );
  }

  // Company information (name, location, rating)
  Widget _buildCompanyInfo() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            company['name'] ?? 'Unknown Company',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 3),
          _buildInfoRow(
            icon: Icons.location_on,
            text: company['location'] ?? 'Location not specified',
          ),
          const SizedBox(height: 5),
          /* _buildInfoRow(
            icon: Icons.star,
            text: '${company['rating']?.toString() ?? '0.0'} Rating',
            iconColor: Colors.amber,
          ), */
        ],
      ),
    );
  }

  // Helper method for building info rows with icons
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? AppColors.navyBlue,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Company details section (without scrolling)
  Widget _buildCompanyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          company['description'] ?? 'No description available',
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 12,
            height: 1.4,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 15),
        const Text(
          'Available Jobs',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildJobsList(company['jobs'] ?? []).take(3).toList(),
        ),
      ],
    );
  }

  // Jobs list
  List<Widget> _buildJobsList(List<dynamic> jobs) {
    if (jobs.isEmpty) {
      return [
        const Text(
          'No jobs available',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 14,
          ),
        )
      ];
    }

    return jobs
        .take(3)
        .map((job) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInfoRow(
                icon: Icons.work,
                text: job.toString(),
              ),
            ))
        .toList();
  }

  // View Details button
  Widget _buildViewDetailsButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onViewDetails,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.tealDark,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'View Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
