import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String email;
  final String password;

  User({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'email': email,
      'password': password, // In production, never store plain passwords
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, gender: $gender, dateOfBirth: $dateOfBirth, email: $email)';
  }
}

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;

  // Method to register a new user
  Future<bool> registerUser({
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    required String email,
    required String password,
  }) async {
    try {
      // Check if email already exists in Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        debugPrint('Email already exists in database: $email');
        return false; // Email already exists in database
      }

      // Create new user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create new user object
      final newUser = User(
        id: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        email: email,
        password: password, // In production, don't store plain passwords
      );

      // Add user to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      debugPrint('User registered in Firestore: $newUser');

      return true;
    } catch (e) {
      // Handle Firebase Auth specific errors
      if (e is firebase_auth.FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          debugPrint('Email already in use in Firebase Auth: $email');
          return false;
        }
      }
      debugPrint('Error registering user: $e');
      return false;
    }
  }

  // Method to sign in a user
  Future<bool> signIn(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        _currentUser = User.fromMap(userData, userCredential.user!.uid);
        return true;
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      return false;
    }
  }

  // Method to sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // If user cancels the sign-in process
      if (googleUser == null) {
        debugPrint('Google sign-in was cancelled by user');
        return false;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Check if we have valid tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint('Failed to get authentication tokens');
        return false;
      }
      
      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) {
        debugPrint('Failed to sign in with Firebase');
        return false;
      }
      
      debugPrint('Successfully signed in with Google: ${user.email}');

      // Check if this is a new user or existing user
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      
      // If user doesn't exist in Firestore yet, create a new record
      if (!docSnapshot.exists) {
        // Split the display name into first and last name
        List<String> nameParts = (user.displayName ?? '').split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        // Join all remaining parts for the last name, or use an empty string if there are no remaining parts
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        // Create a new user record in Firestore
        final newUser = User(
          id: user.uid,
          firstName: firstName,
          lastName: lastName,
          gender: 'Not specified', // Default value
          dateOfBirth: DateTime(2000), // Default value
          email: user.email ?? '',
          password: '', // No password for social login
        );

        // Store user data in Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());
            
        debugPrint('New user created in Firestore for Google Sign In: ${newUser.email}');
        
        // Set current user
        _currentUser = newUser;
      } else {
        // User exists, load their data
        final userData = docSnapshot.data() as Map<String, dynamic>;
        _currentUser = User.fromMap(userData, user.uid);
        debugPrint('Existing user found in Firestore: ${_currentUser?.email}');
      }
      
      return true;
    } catch (e) {
      // Log specific error for debugging
      debugPrint('Error signing in with Google: $e');
      return false;
    }
  }

  User? get currentUser => _currentUser;

  static bool isUserSignedIn() {
    return AuthService()._firebaseAuth.currentUser != null;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }
}
