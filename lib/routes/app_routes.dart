import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/admin/admin_dashboard_screen.dart';
import '../views/admin/manage_users/add_user_screen.dart';
import '../views/admin/manage_users/user_list_screen.dart';
import '../views/admin/manage_leave_requests/leave_requests_screen.dart';
import '../views/user/dashboard/user_dashboard_screen.dart';
import '../views/user/self_service/profile_screen.dart';
import '../views/user/self_service/attendance_screen.dart';
import '../views/user/self_service/leave_request_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String adminDashboard = '/adminDashboard';
  static const String userDashboard = '/userDashboard';
  static const String addUser = '/addUser';
  static const String userList = '/userList';
  static const String leaveRequests = '/leaveRequests';
  static const String profile = '/profile';
  static const String attendance = '/attendance';
  static const String leaveRequest = '/leaveRequest';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case userDashboard:
        return MaterialPageRoute(builder: (_) => const UserDashboardScreen());

      case addUser:
        return MaterialPageRoute(builder: (_) => const AddUserScreen());

      case userList:
        return MaterialPageRoute(builder: (_) => const UserListScreen());

      case leaveRequests:
        return MaterialPageRoute(builder: (_) => const LeaveRequestsScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());

      case leaveRequest:
        return MaterialPageRoute(builder: (_) => const LeaveRequestScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
