import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';

class JobCard extends StatelessWidget {
  final Map<String, String> job;
  final double scale;
  final Function calculateDaysLeft;
  final VoidCallback? onApplyPressed;

  const JobCard({
    super.key,
    required this.job,
    this.scale = 1.0,
    required this.calculateDaysLeft,
    this.onApplyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              // Left column - Image (with fixed width)
              SizedBox(
                width: 145,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.asset(
                    job['image']!,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
              // Right column - Text content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top content area
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Employment type and application count row
                          Row(
                            children: [
                              Text(
                                job['employement_type'] ?? "Not specified",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              
                              // Add space between employment type and application count
                              const SizedBox(width: 8),
                              
                              // Application count badge
                              if (job['application_count'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.tealDark.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 12,
                                        color: AppColors.tealDark,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${job['application_count']} Applied',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.tealDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          
                          const SizedBox(height: 5),
                          Text(
                            job['company']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            job['location']!,
                            style: const TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            job['description']!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, color: AppColors.primaryBlue),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            job['salary'] ?? "Salary not specified",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          
                          Text(
                            calculateDaysLeft(job['deadline']),
                            style: TextStyle(
                              fontSize: 12, 
                              color: calculateDaysLeft(job['deadline']) == "Deadline passed" 
                                  ? Colors.red 
                                  : AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      // Apply button
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 50),
                          child: ElevatedButton(
                            onPressed: calculateDaysLeft(job['deadline']) == "Deadline passed" 
                                ? null
                                : onApplyPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tealDark,
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                              minimumSize: const Size(100, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Apply Now',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
}
