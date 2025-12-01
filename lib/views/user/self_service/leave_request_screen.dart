import 'package:flutter/material.dart';
import 'package:personal_app/core/constants/app_strings.dart';
import 'package:personal_app/views/user/self_service/leave_status_card.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/leave_view_model.dart';
import '../../../data/models/leave_model.dart';
import '../../../core/services/local_storage_service.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime today = DateTime.now();
  DateTime lastDate = DateTime(2100);
  DateTime? selectedInitialDate;
  DateTime? selectedFinalDate;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _finaldateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LeaveViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1a1a1a)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Request Leave',
          style: TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: LocalStorageService.getUserId(),
                  builder: (context, snapshotdata) {
                    return StreamBuilder(
                      stream: vm.getLeaves(snapshotdata.data ?? ''),
                      builder: (context, asyncSnapshot) {
                        if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final leaves = asyncSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Leave Requests',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1a1a1a),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: leaves.length,
                              itemBuilder: (context, index) {
                                final leave = leaves[index];
                                return LeaveStatusCard(
                                  leave: LeaveModel(
                                    id: leave.id,
                                    userId: leave.userId,
                                    startDate: leave.startDate,
                                    endDate: leave.endDate,
                                    reason: leave.reason,
                                    status: leave.status,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    );
                  },
                ),
                const Text(
                  'New Leave Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _reasonController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Reason',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            hintText: 'Enter your reason for leave',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF4caf50), width: 2),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F7FA),
                          ),
                          validator: (value) => value!.isEmpty ? 'Reason required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  labelStyle: TextStyle(color: Colors.grey.shade600),
                                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF4caf50), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F7FA),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: today,
                                    firstDate: today,
                                    lastDate: lastDate,
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      selectedInitialDate = picked;
                                      _dateController.text = "${picked.toLocal()}".split(' ')[0];
                                      // if (selectedFinalDate != null && selectedFinalDate!.isBefore(picked)) {
                                      //   selectedFinalDate = null;
                                      //   _finaldateController.clear();
                                      // }
                                    });
                                  }
                                },
                                validator: (value) => value!.isEmpty ? 'Start date required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _finaldateController,
                                decoration: InputDecoration(
                                  labelText: 'End Date',
                                  labelStyle: TextStyle(color: Colors.grey.shade600),
                                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF4caf50), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F7FA),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  // if (selectedInitialDate == null) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: const Text('Please select start date first'),
                                  //       backgroundColor: Colors.orange,
                                  //       behavior: SnackBarBehavior.floating,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(8),
                                  //       ),
                                  //     ),
                                  //   );
                                  //   return;
                                  // }

                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedInitialDate!,
                                    firstDate: selectedInitialDate!,
                                    lastDate: lastDate,
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      selectedFinalDate = picked;
                                      _finaldateController.text = "${picked.toLocal()}".split(' ')[0];
                                    });
                                  }
                                },
                                validator: (value) => value!.isEmpty ? 'End date required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && selectedInitialDate != null && selectedFinalDate != null) {
                                final userId = await LocalStorageService.getUserId();
                                if (userId != null) {
                                  final leave = LeaveModel(
                                    id: DateTime.now().toString(),
                                    userId: userId,
                                    startDate: selectedInitialDate!,
                                    endDate: selectedFinalDate!,
                                    reason: _reasonController.text,
                                    status: 'pending',
                                  );
                                  await vm.submitLeave(leave);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4caf50),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              AppStrings.submit,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}