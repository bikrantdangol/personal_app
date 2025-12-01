import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_app/data/models/user_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/local_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _currentUSer ;
   UserModel? currentUserDetail;

  User? get user => _currentUSer;

  bool get isLoading => _isLoading;

  String? get role => currentUserDetail?.role;
  

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
       _currentUSer = await _authService.signIn(email, password);
      if (_currentUSer != null) {
        print("This is the uid : ${_currentUSer!.uid}");
        currentUserDetail = await _authService.getUserData(_currentUSer!.uid);
        print("This is current User data : $currentUserDetail");
        await LocalStorageService.saveUserId(_currentUSer!.uid);
      }
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Change password
      await user.updatePassword(newPassword);
      
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error changing password: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}