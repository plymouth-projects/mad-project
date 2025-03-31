import 'package:mad_project/models/job_model.dart';
import 'package:mad_project/constants/filter_options.dart';

/// Service class for handling job-related operations
class JobService {
  // Singleton pattern
  static final JobService _instance = JobService._internal();
  
  factory JobService() {
    return _instance;
  }
  
  JobService._internal();
  
  // Sample job data - in a real app, this would come from an API or database
  final List<Map<String, String>> _jobs = const [
    {
      'title': 'Babysitter',
      'company': 'Family Care',
      'location': 'New York, NY',
      'description': 'A senior babysitter with 3+ years of experience.',
      'image': 'assets/images/babysitter.png',
      'salary': 'Rs. 75,000/Month',
      'deadline': '2025-12-30',
      'employement_type': 'Part-time',
      'seniority_level': 'Mid-Level',
      'application_count': '12',
    },
    {
      'title': 'Dog Walker',
      'company': 'Pet Services',
      'location': 'Boston, MA',
      'description': 'Walk dogs in the neighborhood, experience required.',
      'image': 'assets/images/babysitter.png',
      'salary': 'Rs. 40,000/Month',
      'deadline': '2025-12-25',
      'employement_type': 'Freelance',
      'seniority_level': 'Entry Level',
      'application_count': '8',
    },
    {
      'title': 'Chef',
      'company': 'Gourmet Restaurant',
      'location': 'Chicago, IL',
      'description': 'Experienced chef needed for upscale restaurant.',
      'image': 'assets/images/babysitter.png',
      'salary': 'Rs. 95,000/Month',
      'deadline': '2025-11-15',
      'employement_type': 'Full-time',
      'seniority_level': 'Senior',
      'application_count': '24',
    },
    {
      'title': 'Delivery Driver',
      'company': 'Quick Delivery',
      'location': 'Los Angeles, CA',
      'description': 'Reliable driver needed for package deliveries.',
      'image': 'assets/images/babysitter.png',
      'salary': 'Rs. 35,000/Month',
      'deadline': '2025-12-10',
      'employement_type': 'Contract',
      'seniority_level': 'Entry Level',
      'application_count': '5',
    },
  ];
  
  /// Get all available jobs
  List<Map<String, String>> getAllJobs() {
    return List.from(_jobs);
  }
  
  /// Get all available jobs as Job objects
  List<Job> getAllJobObjects() {
    return _jobs.map((jobMap) => Job.fromMap(jobMap)).toList();
  }
  
  /// Get jobs filtered by criteria
  List<Map<String, String>> getFilteredJobs({
    String? employmentType,
    String? seniorityLevel,
    String? salaryRange,
    String? searchTerm,
  }) {
    return _jobs.where((job) {
      // Filter by employment type
      bool matchesEmploymentType = employmentType == null || 
                                  job['employement_type'] == employmentType;
      
      // Filter by seniority level
      bool matchesSeniorityLevel = seniorityLevel == null || 
                                 job['seniority_level'] == seniorityLevel;
      
      // Filter by salary range
      bool matchesSalaryRange = true;
      if (salaryRange != null) {
        // Extract numeric salary (assuming format like "Rs. 75,000/Month")
        final salaryStr = job['salary'] ?? '';
        final numericSalary = _extractNumericSalary(salaryStr);
        
        if (numericSalary != null && FilterOptions.salaryRangeValues.containsKey(salaryRange)) {
          final range = FilterOptions.salaryRangeValues[salaryRange]!;
          matchesSalaryRange = numericSalary >= range['min'] && numericSalary <= range['max'];
        }
      }
      
      // Filter by search term
      bool matchesSearchTerm = searchTerm == null || searchTerm.isEmpty || 
                            job['title']?.toLowerCase().contains(searchTerm.toLowerCase()) == true ||
                            job['company']?.toLowerCase().contains(searchTerm.toLowerCase()) == true ||
                            job['description']?.toLowerCase().contains(searchTerm.toLowerCase()) == true;
      
      return matchesEmploymentType && 
             matchesSeniorityLevel && 
             matchesSalaryRange && 
             matchesSearchTerm;
    }).toList();
  }
  
  /// Get jobs filtered by criteria as Job objects
  List<Job> getFilteredJobObjects({
    String? employmentType,
    String? seniorityLevel,
    String? salaryRange,
    String? searchTerm,
  }) {
    final filteredMaps = getFilteredJobs(
      employmentType: employmentType,
      seniorityLevel: seniorityLevel,
      salaryRange: salaryRange,
      searchTerm: searchTerm,
    );
    
    return filteredMaps.map((jobMap) => Job.fromMap(jobMap)).toList();
  }
  
  /// Helper method to extract numeric salary from string
  int? _extractNumericSalary(String salaryStr) {
    // Extract numeric part from strings like "Rs. 75,000/Month"
    final RegExp regex = RegExp(r'Rs\.\s*([0-9,]+)');
    final match = regex.firstMatch(salaryStr);
    
    if (match != null && match.groupCount >= 1) {
      final numericStr = match.group(1)?.replaceAll(',', '');
      if (numericStr != null) {
        return int.tryParse(numericStr);
      }
    }
    
    return null;
  }
  
  /// Get job by id or index
  Map<String, String>? getJobById(int index) {
    if (index >= 0 && index < _jobs.length) {
      return _jobs[index];
    }
    return null;
  }
  
  /// Apply for a job
  Future<bool> applyForJob(Map<String, String> job, Map<String, dynamic> applicationData) async {
    // In a real app, this would send the application to an API or database
    // For now, just simulate success after a small delay
    await Future.delayed(const Duration(seconds: 1));
    
    print('Applied for ${job['title']} with data: $applicationData');
    return true;
  }
  
  /// Apply for a job with a structured application
  Future<bool> submitJobApplication(Job job, JobApplication application) async {
    // In a real app, this would send the application to an API or database
    await Future.delayed(const Duration(seconds: 1));
    
    print('Submitted application: ${application.toMap()}');
    return true;
  }
  
  /// Get recommended jobs based on user preferences or history
  List<Map<String, String>> getRecommendedJobs() {
    // In a real app, this would use some algorithm to suggest relevant jobs
    // For now, just return a subset of jobs
    return _jobs.take(2).toList();
  }
}
