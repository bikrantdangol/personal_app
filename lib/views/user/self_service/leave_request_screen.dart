import 'package:flutter/material.dart';
import 'package:personal_app/core/constants/app_strings.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LeaveViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Request Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
                validator: (value) => value!.isEmpty ? 'Reason required' : null,
              ),
              // Add date pickers for start/end
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
                    final userId = await LocalStorageService.getUserId();
                    if (userId != null) {
                      final leave = LeaveModel(
                        id: DateTime.now().toString(),
                        userId: userId,
                        startDate: _startDate!,
                        endDate: _endDate!,
                        reason: _reasonController.text,
                        status: 'pending',
                      );
                      await vm.submitLeave(leave);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(AppStrings.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}