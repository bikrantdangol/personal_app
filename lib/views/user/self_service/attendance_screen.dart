import 'package:flutter/material.dart';
import 'package:personal_app/core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/attendance_view_model.dart';
import '../../../data/models/attendance_model.dart';
import '../../../core/services/local_storage_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AttendanceViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.attendance)),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final userId = await LocalStorageService.getUserId();
            if (userId != null) {
              final attendance = AttendanceModel(
                id: DateTime.now().toString(),
                userId: userId,
                date: DateTime.now(),
                present: true,
              );
              await vm.markAttendance(attendance);
            }
          },
          child: const Text('Mark Present'),
        ),
      ),
    );
  }
}