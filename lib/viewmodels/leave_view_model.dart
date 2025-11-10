import 'package:flutter/material.dart';
import '../data/models/leave_model.dart';
import '../data/repositories/leave_repository.dart';

class LeaveViewModel extends ChangeNotifier {
  final LeaveRepository _leaveRepo = LeaveRepository();

  Future<void> submitLeave(LeaveModel leave) async {
    await _leaveRepo.submitLeave(leave);
  }
}