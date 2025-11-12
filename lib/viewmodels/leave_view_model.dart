import 'package:flutter/material.dart';
import '../data/models/leave_model.dart';
import '../data/repositories/leave_repository.dart';

class LeaveViewModel extends ChangeNotifier {
  final LeaveRepository _leaveRepo = LeaveRepository();

  Future<void> updateLeaveStatus(String leaveId, String status) async {
  await _leaveRepo.updateLeaveStatus(leaveId, status);
  notifyListeners();
}


  Future<void> submitLeave(LeaveModel leave) async {
    await _leaveRepo.submitLeave(leave);
  }

  
    Stream<List<LeaveModel>> getLeaves(String userId) {
    return _leaveRepo.getLeaves(userId);

    
  }
}