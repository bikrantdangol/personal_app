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

  Future<void> logout() async {
    await _authService.signOut();
  }
}