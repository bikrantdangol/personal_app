// ... existing imports
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_app/core/constants/app_strings.dart';
import 'package:personal_app/viewmodels/admin_view_model.dart';
import 'package:provider/provider.dart';

class LeaveRequestsScreen extends StatelessWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminVM = Provider.of<AdminViewModel>(context);
    adminVM.loadLeaveRequests();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.leaveRequests)),  // Remove const
      // ... rest of the code remains the same
    );
  }
}