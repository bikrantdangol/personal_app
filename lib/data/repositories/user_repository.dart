import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addUser(UserModel user, String password) async {
  
    try {
     UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      String uid = credential.user!.uid;
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
    } catch (e) {
      print("Error creating Firebase user: $e");
    }
    return password;
  }

    Future<QuerySnapshot> listAllUsers(String apiEndpoint) async {
    QuerySnapshot users; 
    try {
    users =   await _apiService.getAllDocuments(
       apiEndpoint
      );
    } catch (e) {
      throw Exception("Error fetching the users: $e");
    }
    return users;
  }

  // Future<void> deleteUser(String userId) async {
  //   try {
  //     // Delete user document from Firestore
  //     await _apiService.deleteDocument(
  //       ApiEndpoints.usersCollection,
  //       userId,
  //     );
      
  //     // Note: Deleting from Firebase Auth requires admin privileges
  //     // This will only delete from Firestore
  //     // To delete from Firebase Auth, you need Firebase Admin SDK on backend
      
  //   } catch (e) {
  //     print("Error deleting user: $e");
  //     throw Exception("Error deleting user: $e");
  //   }
  // }

 Future<User?> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
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

  Future<void> logout() async {
    await _auth.signOut();
  }

}