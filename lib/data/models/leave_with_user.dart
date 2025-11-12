import 'package:personal_app/data/models/leave_model.dart';
import 'package:personal_app/data/models/user_model.dart';

class LeaveWithUser {
  final LeaveModel leave;
  final UserModel user;

  LeaveWithUser({required this.leave, required this.user});
}
