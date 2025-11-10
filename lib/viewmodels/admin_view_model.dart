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

  Future<void> loadUsers() async {
    // Load all users (in real app, paginate)
    // For simplicity, assume fetching from Firestore
    notifyListeners();
  }

  Future<void> loadLeaveRequests() async {
    // Load pending leaves
    notifyListeners();
  }

  Future<void> approveLeave(String id) async {
    await _leaveRepo.updateLeaveStatus(id, 'approved');
    loadLeaveRequests();
  }
}