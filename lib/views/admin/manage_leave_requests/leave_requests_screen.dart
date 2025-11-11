import 'package:flutter/material.dart';
import 'package:personal_app/data/models/leave_model.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveRequestsScreen> {
  // Sample Data
  List<LeaveModel> leaves = [
    // data
  ];

  // Action Handlers (currently empty actions)
  void approveLeave(LeaveModel leave) {
    print("Approved: ${leave.id}");
  }

  void rejectLeave(LeaveModel leave) {
    print("Rejected: ${leave.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: leaves.length,
        itemBuilder: (context, index) {
          final leave = leaves[index];
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
                  // Left side leave information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User ID: ${leave.userId}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text("From: ${leave.startDate.toString().split(' ')[0]}"),
                        Text("To:   ${leave.endDate.toString().split(' ')[0]}"),
                        const SizedBox(height: 6),
                        Text("Reason: ${leave.reason}"),
                        const SizedBox(height: 6),
                        Text(
                          "Status: ${leave.status.toUpperCase()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: leave.status == "approved"
                                ? Colors.green
                                : leave.status == "rejected"
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side buttons
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => approveLeave(leave),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text("Approve"),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () => rejectLeave(leave),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text("Reject"),
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
