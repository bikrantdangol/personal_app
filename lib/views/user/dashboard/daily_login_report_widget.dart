import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_dashboard_view_model.dart';

class DailyLoginReportWidget extends StatelessWidget {
  const DailyLoginReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserDashboardViewModel>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Attendance Records: ${vm.attendance.length} entries'),
      ),
    );
  }
}