import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/models/job_model.dart';
import 'package:mad_project/services/job_service.dart';
import 'package:mad_project/utils/date_utils.dart' as app_date_utils;
import 'package:mad_project/widgets/navbar.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final JobService _jobService = JobService();
  
  @override
  Widget build(BuildContext context) {
    // Get job data from route arguments
    final Map<String, String> jobData = 
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    
    // Convert to Job model if needed
    final Job job = Job.fromMap(jobData);
    
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.jobHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.jobHub),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJobHeader(job),
              const SizedBox(height: 24),
              _buildCompanyInfo(job),
              const SizedBox(height: 24),
              _buildJobDetails(job),
              const SizedBox(height: 24),
              _buildJobDescription(job),
              const SizedBox(height: 32),
              _buildApplicationButton(job),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildJobHeader(Job job) {
    return Column(
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
              'JOB DETAILS',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCompanyInfo(Job job) {
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    image: job.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: AssetImage(job.imageUrl),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                  child: job.imageUrl.isEmpty
                      ? const Icon(Icons.business, color: Color(0xFF0E3A5D), size: 40)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.location_on,
                            job.location,
                            AppColors.tealDark,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.people,
                            '${job.applicationCount} applicants',
                            Colors.blue.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  Icons.work,
                  job.employmentType,
                  Colors.purple.shade700,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.trending_up,
                  job.seniorityLevel,
                  Colors.orange.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildJobDetails(Job job) {
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
              'Job Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailItem(
              'Salary',
              job.salary,
              Icons.attach_money,
            ),
            const Divider(color: Colors.white24),
            _buildDetailItem(
              'Deadline',
              '(${app_date_utils.DateUtils.calculateDaysLeft(job.deadline)} days left)',
              Icons.timer,
            ),
            const Divider(color: Colors.white24),
            _buildDetailItem(
              'Employment Type',
              job.employmentType,
              Icons.work,
            ),
            const Divider(color: Colors.white24),
            _buildDetailItem(
              'Experience Level',
              job.seniorityLevel,
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value, IconData icon) {
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
  
  Widget _buildJobDescription(Job job) {
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
              'Job Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              job.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildApplicationButton(Job job) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _submitApplication(job),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tealDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'APPLY NOW',
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
  
  void _submitApplication(Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply for ${job.title}?'),
        content: Text('Do you want to apply for this position at ${job.company}?'),
        backgroundColor: const Color(0xFF0E3A5D),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Convert Map<String, dynamic> to Map<String, String>
              Map<String, dynamic> jobMap = job.toMap();
              Map<String, String> jobStringMap = jobMap.map((key, value) => 
                MapEntry(key, value.toString()));
                
              final result = await _jobService.applyForJob(
                jobStringMap, 
                {'userId': 'current_user_id'}
              );
              
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Applied successfully for ${job.title}!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate back to job hub after successful application
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to apply for the job. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealDark,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
