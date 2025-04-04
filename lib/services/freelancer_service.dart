import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/list_utils.dart';

class FreelancerService {
  // Singleton pattern 
  static final FreelancerService _instance = FreelancerService._internal();
  
  factory FreelancerService() {
    return _instance;
  }
  
  FreelancerService._internal();
  
  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'freelancers';
  
  // Get all freelancers data
  Future<List<Map<String, dynamic>>> getFreelancers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data
        
        // Process any list fields to ensure proper type safety
        if (data.containsKey('skills') && data['skills'] is List) {
          data['skills'] = ListUtils.toStringList(data['skills']);
        }
        
        // Process other lists as needed
        // Add similar conversions for other list fields
        
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching freelancers: $e');
      throw Exception('Failed to load freelancers: $e');
    }
  }
  
  // Get featured freelancers
  Future<List<Map<String, dynamic>>> getFeaturedFreelancers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Process any list fields to ensure proper type safety
        if (data.containsKey('skills') && data['skills'] is List) {
          data['skills'] = ListUtils.toStringList(data['skills']);
        }
        
        // Process other lists that might be present
        if (data.containsKey('languages') && data['languages'] is List) {
          data['languages'] = ListUtils.toStringList(data['languages']);
        }
        
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching featured freelancers: $e');
      throw Exception('Failed to load featured freelancers: $e');
    }
  }
  
  // Get freelancers by skill
  Future<List<Map<String, dynamic>>> getFreelancersBySkill(String skill) async {
    try {
      // Using array-contains to find documents where the skills array contains the specified skill
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('skills', arrayContains: skill)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching freelancers by skill: $e');
      throw Exception('Failed to load freelancers by skill: $e');
    }
  }
  
  // Get freelancers by level
  Future<List<Map<String, dynamic>>> getFreelancersByLevel(String level) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('level', isEqualTo: level)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Process any list fields to ensure proper type safety
        if (data.containsKey('skills') && data['skills'] is List) {
          data['skills'] = ListUtils.toStringList(data['skills']);
        }
        
        if (data.containsKey('languages') && data['languages'] is List) {
          data['languages'] = ListUtils.toStringList(data['languages']);
        }
        
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching freelancers by level: $e');
      throw Exception('Failed to load freelancers by level: $e');
    }
  }
  
  // Get freelancer by ID
  Future<Map<String, dynamic>?> getFreelancerById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching freelancer by ID: $e');
      throw Exception('Failed to load freelancer details: $e');
    }
  }
}
