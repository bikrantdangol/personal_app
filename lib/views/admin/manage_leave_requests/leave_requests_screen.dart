import 'package:flutter/material.dart';
import 'package:personal_app/data/models/leave_model.dart';
import 'package:personal_app/viewmodels/admin_view_model.dart';
import 'package:personal_app/viewmodels/leave_view_model.dart';
import 'package:provider/provider.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
void deleteLeave(LeaveModel leave) async {
  final vm = Provider.of<LeaveViewModel>(context, listen: false);

  try {
    await vm.deleteLeave(leave);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave deleted successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting leave: $e")),
    );
  }
}

  void approveLeave(LeaveModel leave) async {
    final vm = Provider.of<LeaveViewModel>(context, listen: false);
    await vm.updateLeaveStatus(leave.userId, 'approved');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave Approved")),
    );
  }

  void rejectLeave(LeaveModel leave) async {
    final vm = Provider.of<LeaveViewModel>(context, listen: false);
    await vm.updateLeaveStatus(leave.userId, 'rejected');
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text("Leave Rejected")),
  );
}
   
 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<AdminViewModel>(context, listen: false).loadLeaveRequests();
  });
}


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      appBar: AppBar(
        title: const Text("Leave Requests"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.leaveRequests.length,
        itemBuilder: (context, index) {
          final leave = vm.leaveRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name: ${leave.user.name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text("From: ${leave.leave.startDate.toString().split(' ')[0]}"),
                        Text("To:   ${leave.leave.endDate.toString().split(' ')[0]}"),
                        const SizedBox(height: 6),
                        Text("Reason: ${leave.leave.reason}"),
                        const SizedBox(height: 6),
                        Text(
                          "Status: ${leave.leave.status.toUpperCase()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: leave.leave.status == "approved"
                                ? Colors.green
                                : leave.leave.status == "rejected"
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if(leave.leave.status == "pending")
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => approveLeave(leave.leave),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text("Approve"),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () => rejectLeave(leave.leave),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text("Reject"),
                      ),
                    ],
                  ),
                   if(leave.leave.status != "pending")
                   Column(
                     children: [
                       Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                         "Reviewed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                         ),
                     const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () => deleteLeave(leave.leave),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text("Delete"),
                      ),

                     ],
                   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
