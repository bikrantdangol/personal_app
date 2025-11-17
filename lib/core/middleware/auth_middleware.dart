import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMiddleware {
  static String? _cachedRole; 
  
  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future<String?> loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null; 
    if (_cachedRole != null) return _cachedRole;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      _cachedRole = doc.data()?['role'] as String?;
      return _cachedRole;
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  static String getUserRole() {
    return _cachedRole ?? "";
  }

  static Future<void> logout() async {
    _cachedRole = null;
    await FirebaseAuth.instance.signOut();
  }
}
