import 'package:flutter/material.dart';
import '../data/models/attendance_model.dart';
import '../data/repositories/attendance_repository.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceRepository _attendanceRepo = AttendanceRepository();

  Future<void> markAttendance(AttendanceModel attendance) async {
    await _attendanceRepo.markAttendance(attendance);
  }
}