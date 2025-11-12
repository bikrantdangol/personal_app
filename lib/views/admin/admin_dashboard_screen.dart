import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../viewmodels/admin_view_model.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../routes/app_routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminVM = Provider.of<AdminViewModel>(context, listen: false);
      adminVM.loadUsers();
      adminVM.loadLeaveRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminVM = Provider.of<AdminViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      appBar: AppBar(
        title: Text('${AppStrings.appName} - Admin ${AppStrings.dashboard}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthViewModel>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Users'),
                          Text('${adminVM.users.length}', style: const TextStyle(fontSize: 24,)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Pending applicants'),
                          Text('${adminVM.leaveRequests.where((l) => l.leave.status == 'pending').length}', style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.userList),
              child: const Text('Manage Users'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.leaveRequests),
              child: Text(AppStrings.leaveRequests),
            ),
          ],
        ),
      ),
    );
  }
}