import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_dashboard_view_model.dart';

class LeaveBalanceWidget extends StatelessWidget {
  const LeaveBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserDashboardViewModel>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Leave Balance: ${vm.leaveBalance} days'),
      ),
    );
  }
}