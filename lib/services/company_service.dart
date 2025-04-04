import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'companies';

  // Get all companies from Firestore
  Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting companies: $e');
      return [];
    }
  }
  
  // Get a single company by ID
  Future<Map<String, dynamic>?> getCompanyById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting company by ID: $e');
      return null;
    }
  }
}
