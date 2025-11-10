import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMiddleware {
  static String? _cachedRole; 

  /// Checks if user is logged in
  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Loads the role from Firestore if not loaded yet
  static Future<String?> loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null; // No user logged in

    // If role is already fetched, return it
    if (_cachedRole != null) return _cachedRole;

    // Fetch role from Firestore
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

  /// Returns stored role (after loadUserRole executed)
  static String getUserRole() {
    return _cachedRole ?? "";
  }

  /// Call this on logout to clear cached role
  static Future<void> logout() async {
    _cachedRole = null;
    await FirebaseAuth.instance.signOut();
  }
}
