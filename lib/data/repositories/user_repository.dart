import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create new user (Admin action)
  Future<String> addUser(UserModel user, String password) async {
    try {
      // Create user in Firebase Auth
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      String uid = credential.user!.uid;

      // Save user data to Firestore
      await _apiService.setDocument(
        ApiEndpoints.usersCollection,
        uid,
        {
          'id': uid,
          'email': user.email,
          'name': user.name,
          'role': user.role,
        },
      );

      print("User created successfully with UID: $uid");

      // Important: sign out newly created user
      await _auth.signOut();

      return uid;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      throw Exception("Failed to create user: ${e.message}");
    } catch (e) {
      print("Error creating user: $e");
      throw Exception("Failed to create user: $e");
    }
  }

  /// Fetch all users
  Future<QuerySnapshot> listAllUsers(String apiEndpoint) async {
    try {
      return await _apiService.getAllDocuments(apiEndpoint);
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  /// Delete user document (Firestore only)
  Future<void> deleteUser(String userId) async {
    try {
      await _apiService.deleteDocument(
        ApiEndpoints.usersCollection,
        userId,
      );
    } catch (e) {
      print("Error deleting user: $e");
      throw Exception("Error deleting user: $e");
    }
  }

  /// Login user
  Future<User?> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print('Login failed: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
