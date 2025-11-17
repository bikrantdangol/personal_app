import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminViewModel>(context, listen: false).loadLeaveRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1a1a1a)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Leave Requests",
          style: TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'All Leave Requests',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${vm.leaveRequests.length} total requests',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vm.leaveRequests.length,
                itemBuilder: (context, index) {
                  final leave = vm.leaveRequests[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leave.user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF1a1a1a),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${leave.leave.startDate.toString().split(' ')[0]} - ${leave.leave.endDate.toString().split(' ')[0]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.description_outlined,
                                        size: 14,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        leave.leave.reason,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: leave.leave.status == "approved"
                                        ? const Color(0xFFe8f5e9)
                                        : leave.leave.status == "rejected"
                                            ? const Color(0xFFffebee)
                                            : const Color(0xFFfff8e1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    leave.leave.status.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: leave.leave.status == "approved"
                                          ? const Color(0xFF2e7d32)
                                          : leave.leave.status == "rejected"
                                              ? const Color(0xFFc62828)
                                              : const Color(0xFFf57c00),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),
                          if (leave.leave.status == "pending")
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => approveLeave(leave.leave),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4caf50),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Approve",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () => rejectLeave(leave.leave),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFe53935),
                                    side: const BorderSide(
                                        color: Color(0xFFe53935), width: 1.5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Reject",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          if (leave.leave.status != "pending")
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4caf50),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Reviewed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () => deleteLeave(leave.leave),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF757575),
                                    side: BorderSide(
                                        color: Colors.grey.shade400, width: 1.5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Delete",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
