import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_app/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("This is the credientials: $result");
      return result.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  Future<UserModel?> getUserData(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
   print("This is the data:${doc.data()}}");
  if (doc.exists) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
  return null;
}


  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}