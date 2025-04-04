import 'package:mad_project/models/job_model.dart';
import 'package:mad_project/constants/jobs_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for handling job-related operations using Firestore
class JobService {
  // Singleton pattern
  static final JobService _instance = JobService._internal();
  
  factory JobService() {
    return _instance;
  }
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'jobs';
  
  JobService._internal();
  
  
  /// Get all available jobs
  Future<List<Map<String, dynamic>>> getAllJobs() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Include the document ID
      return Map<String, dynamic>.from(data);
    }).toList();
  }
  
  /// Get all available jobs as Job objects
  Future<List<Job>> getAllJobObjects() async {
    final jobs = await getAllJobs();
    return jobs.map((jobMap) => Job.fromMap(jobMap)).toList();
  }
  
  /// Get jobs filtered by criteria
  Future<List<Map<String, dynamic>>> getFilteredJobs({
    String? employmentType,
    String? seniorityLevel,
    String? salaryRange,
    String? searchTerm,
  }) async {
    // Start with a base query
    Query query = _firestore.collection(_collectionName);
    
    // Apply filters that can be done directly in Firestore
    if (employmentType != null) {
      query = query.where('employement_type', isEqualTo: employmentType);
    }
    
    if (seniorityLevel != null) {
      query = query.where('seniority_level', isEqualTo: seniorityLevel);
    }
    
    // Execute the query
    final QuerySnapshot snapshot = await query.get();
    
    // Get the results as a list of maps
    List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Map<String, dynamic>.from(data);
    }).toList();
    
    // Apply client-side filtering for more complex filters
    return results.where((job) {
      // Filter by salary range
      bool matchesSalaryRange = true;
      if (salaryRange != null) {
        final salaryStr = job['salary'] as String? ?? '';
        final numericSalary = _extractNumericSalary(salaryStr);
        
        if (numericSalary != null && FilterOptions.salaryRangeValues.containsKey(salaryRange)) {
          final range = FilterOptions.salaryRangeValues[salaryRange]!;
          matchesSalaryRange = numericSalary >= range['min'] && numericSalary <= range['max'];
        }
      }
      
      // Filter by search term
      bool matchesSearchTerm = searchTerm == null || searchTerm.isEmpty || 
                            job['title']?.toString().toLowerCase().contains(searchTerm.toLowerCase()) == true ||
                            job['company']?.toString().toLowerCase().contains(searchTerm.toLowerCase()) == true ||
                            job['description']?.toString().toLowerCase().contains(searchTerm.toLowerCase()) == true;
      
      return matchesSalaryRange && matchesSearchTerm;
    }).toList();
  }
  
  /// Get jobs filtered by criteria as Job objects
  Future<List<Job>> getFilteredJobObjects({
    String? employmentType,
    String? seniorityLevel,
    String? salaryRange,
    String? searchTerm,
  }) async {
    final filteredMaps = await getFilteredJobs(
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
  
  /// Get job by id
  Future<Map<String, dynamic>?> getJobById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collectionName).doc(id).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error getting job by ID: $e');
      return null;
    }
  }
  
  /// Apply for a job
  Future<bool> applyForJob(Map<String, dynamic> job, Map<String, dynamic> applicationData) async {
    try {
      // Create a new application document in a separate collection
      await _firestore.collection('applications').add({
        'job_id': job['id'],
        'job_title': job['title'],
        'application_data': applicationData,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Increment the application count for the job
      final String jobId = job['id'];
      final DocumentReference jobRef = _firestore.collection(_collectionName).doc(jobId);
      
      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot jobSnapshot = await transaction.get(jobRef);
        
        if (jobSnapshot.exists) {
          final currentCount = int.tryParse(jobSnapshot.get('application_count') ?? '0') ?? 0;
          transaction.update(jobRef, {
            'application_count': (currentCount + 1).toString(),
          });
        }
      });
      
      return true;
    } catch (e) {
      print('Error applying for job: $e');
      return false;
    }
  }
  
  /// Apply for a job with a structured application
  Future<bool> submitJobApplication(Job job, JobApplication application) async {
    // In a real app, this would send the application to an API or database
    await Future.delayed(const Duration(seconds: 1));
    
    print('Submitted application: ${application.toMap()}');
    return true;
  }
  
  /// Get recommended jobs based on user preferences or history
  Future<List<Map<String, dynamic>>> getRecommendedJobs() async {
    // For now, just return a subset of jobs
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).limit(2).get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Map<String, dynamic>.from(data);
    }).toList();
  }
  
  /// Add a new job to Firestore
  Future<String?> addJob(Map<String, dynamic> jobData) async {
    try {
      final DocumentReference docRef = await _firestore.collection(_collectionName).add(jobData);
      return docRef.id;
    } catch (e) {
      print('Error adding job: $e');
      return null;
    }
  }
  
  /// Update an existing job in Firestore
  Future<bool> updateJob(String id, Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(jobData);
      return true;
    } catch (e) {
      print('Error updating job: $e');
      return false;
    }
  }
  
  /// Delete a job from Firestore
  Future<bool> deleteJob(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting job: $e');
      return false;
    }
  }

  /// Store custom data in Firestore
  Future<bool> storeCustomData(String collectionName, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).add({
        ...data,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error storing custom data: $e');
      return false;
    }
  }

  /// Retrieve custom data from Firestore
  Future<List<Map<String, dynamic>>> retrieveCustomData(
    String collectionName, {
    String? fieldFilter,
    dynamic fieldValue,
  }) async {
    try {
      Query query = _firestore.collection(collectionName);
      
      // Apply field filter if provided
      if (fieldFilter != null && fieldValue != null) {
        query = query.where(fieldFilter, isEqualTo: fieldValue);
      }
      
      final QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Map<String, dynamic>.from(data);
      }).toList();
    } catch (e) {
      print('Error retrieving custom data: $e');
      return [];
    }
  }
}
