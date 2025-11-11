import 'package:flutter/material.dart';
import 'package:personal_app/views/user/self_service/leave_request_screen.dart';
import 'package:personal_app/views/user/self_service/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_dashboard_view_model.dart';
import '../../../viewmodels/auth_view_model.dart';
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
    final auth = Provider.of<AuthViewModel>(context);
    final name = auth.currentUserDetail?.name ?? 'User';
    final role = auth.currentUserDetail?.role ?? 'user';

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/login', 
                (route) => false
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CalendarWidget(),
            //const LeaveBalanceWidget(),
            const DailyLoginReportWidget(),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen()));
              },
              child: const Text('Request Leave'),
            ),
            
          ],
        ),
      ),
    );
  }
}