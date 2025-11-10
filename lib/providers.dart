import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/admin_view_model.dart';
import 'viewmodels/user_dashboard_view_model.dart';
import 'viewmodels/leave_view_model.dart';
import 'viewmodels/attendance_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => AdminViewModel()),
  ChangeNotifierProvider(create: (_) => UserDashboardViewModel()),
  ChangeNotifierProvider(create: (_) => LeaveViewModel()),
  ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
];