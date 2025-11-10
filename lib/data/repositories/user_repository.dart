import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addUser(UserModel user, String password) async {
    // Save user in Firestore with your existing user.id
    await _apiService.setDocument(
      ApiEndpoints.usersCollection,
      user.id,
      user.toMap(),
    );
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
    } catch (e) {
      print("⚠ Error creating Firebase user: $e");
    }

    // Return password back to UI
    return password;
  }
}
