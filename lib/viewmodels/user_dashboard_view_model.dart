import 'package:flutter/material.dart';
import '../data/models/leave_model.dart';
import '../data/models/attendance_model.dart';
import '../data/repositories/leave_repository.dart';
import '../data/repositories/attendance_repository.dart';

class UserDashboardViewModel extends ChangeNotifier {
  final LeaveRepository _leaveRepo = LeaveRepository();
  final AttendanceRepository _attendanceRepo = AttendanceRepository();
  List<LeaveModel> _leaves = [];
  List<AttendanceModel> _attendance = [];
  int _leaveBalance = 20; // Example

  List<LeaveModel> get leaves => _leaves;
  List<AttendanceModel> get attendance => _attendance;
  int get leaveBalance => _leaveBalance;

  void loadData(String userId) {
    _leaveRepo.getLeaves(userId).listen((leaves) {
      _leaves = leaves;
      notifyListeners();
    });
    _attendanceRepo.getAttendance(userId).listen((attendance) {
      _attendance = attendance;
      notifyListeners();
    });
  }
}