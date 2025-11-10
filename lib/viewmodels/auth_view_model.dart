import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../core/services/local_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        await LocalStorageService.saveUserId(user.uid);
      }
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    await LocalStorageService.clear();
  }
}