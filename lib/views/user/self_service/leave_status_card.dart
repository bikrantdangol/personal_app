import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_app/data/models/leave_model.dart';

class LeaveStatusCard extends StatelessWidget {
  final LeaveModel leave;

  const LeaveStatusCard({Key? key, required this.leave}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final statusColor = _getStatusColor(leave.status);

    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(
          left: BorderSide(color: statusColor, width: 5),
        ),
      ),
      child: Row(
        children: [
          // Left side: main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dates
                Text(
                  "From: ${dateFormat.format(leave.startDate)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "To:   ${dateFormat.format(leave.endDate)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Reason (shortened)
                Text(
                  "Reason: ${leave.reason}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Right side: Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              border: Border.all(color: statusColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              leave.status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
