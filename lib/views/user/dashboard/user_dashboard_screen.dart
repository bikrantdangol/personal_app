import 'package:flutter/material.dart';
import 'package:personal_app/core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_dashboard_view_model.dart';
import '../../../core/services/local_storage_service.dart';
import 'calendar_widget.dart';
import 'leave_balance_widget.dart';
import 'daily_login_report_widget.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = await LocalStorageService.getUserId();
    if (userId != null) {
      Provider.of<UserDashboardViewModel>(context, listen: false).loadData(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dashboard)),
      body: const Column(
        children: [
          CalendarWidget(),
          LeaveBalanceWidget(),
          DailyLoginReportWidget(),
        ],
      ),
    );
  }
}