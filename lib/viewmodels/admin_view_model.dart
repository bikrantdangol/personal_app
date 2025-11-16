import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_app/data/models/leave_with_user.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/leave_repository.dart';

class AdminViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();
  final LeaveRepository _leaveRepo = LeaveRepository();
  List<UserModel> _users = [];

  List<LeaveWithUser> _leaveRequests = [];

  List<UserModel> get users => _users;
  List<LeaveWithUser> get leaveRequests => _leaveRequests;

  bool isLoading = false;
  StreamSubscription? _leaveSubscription;

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
    if (_users.isEmpty) {
      await fetchUsers();
    }
    await _leaveSubscription?.cancel();

    _leaveSubscription = _leaveRepo
        .getLeavesStream()
        .listen((leaves) {
      _leaveRequests = leaves.map((leave) {
        final user = _users.firstWhere(
          (u) => u.id == leave.userId,
          orElse: () => UserModel(
            id: leave.userId,
            email: '',
            role: '',
            name: 'Unknown User',
          ),
        );
        return LeaveWithUser(leave: leave, user: user);
      }).toList();
      notifyListeners();
    });
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
   @override
  void dispose() {
    _leaveSubscription?.cancel();
    super.dispose();
  }
}