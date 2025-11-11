import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/models/leave_model.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/leave_repository.dart';

class AdminViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();
  final LeaveRepository _leaveRepo = LeaveRepository();
  List<UserModel> _users = [];
  List<LeaveModel> _leaveRequests = [];

  List<UserModel> get users => _users;
  List<LeaveModel> get leaveRequests => _leaveRequests;

  bool isLoading = false;

   Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _userRepo.listAllUsers("users");
      _users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadUsers() async {

    notifyListeners();
  }

  Future<void> loadLeaveRequests() async {
    notifyListeners();
  }

  Future<void> approveLeave(String id) async {
    await _leaveRepo.updateLeaveStatus(id, 'approved');
    loadLeaveRequests();
  }

  
  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final user = await _userRepo.loginUser(email, password);
    isLoading = false;
    notifyListeners();
    return user != null;
  }
}