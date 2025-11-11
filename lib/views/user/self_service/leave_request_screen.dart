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
      appBar: AppBar(title: const Text('Request Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              FutureBuilder(
                future:LocalStorageService.getUserId() ,
                builder: (context, snapshotdata) {
                  return StreamBuilder(
                    stream: vm.getLeaves(snapshotdata.data ?? ''),
                    builder: (context, asyncSnapshot) {
                        if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
         final leaves = asyncSnapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,        
  physics: const NeverScrollableScrollPhysics(), 
                        itemCount: leaves.length,
                        itemBuilder: (context, index) {
                          final leave = leaves[index];
                          return LeaveStatusCard(leave: LeaveModel(
                                    id: leave.id,
                                    userId: leave.userId ,
                                    startDate: leave.startDate,
                                    endDate: leave.endDate,
                                    reason:leave.reason,
                                    status: leave.status,
                                  ),);
                        }
                      );
                    }
                  );
                }
              ),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
                validator: (value) => value!.isEmpty ? 'Reason required' : null,
              ),
    const SizedBox(width: 10),
    Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Select Date'),
            readOnly: true,
            onTap: () async {
              DateTime today = DateTime.now();
              DateTime lastDate = DateTime(2100);
        
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
              });
              }
            },
            validator: (value) => value!.isEmpty ? 'Date required' : null,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            controller: _finaldateController,
            decoration: const InputDecoration(labelText: 'Select Date'),
            readOnly: true,
            onTap: () async {
              DateTime today = DateTime.now();
              DateTime lastDate = DateTime(2100);
        
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: today,
                firstDate: today,
                lastDate: lastDate,
              );
        
              if (picked != null) {
              setState(() {
                  selectedFinalDate = picked;
                _finaldateController.text = "${picked.toLocal()}".split(' ')[0]; 
              });
              }
            },
            validator: (value) => value!.isEmpty ? 'Date required' : null,
          ),
        ),
      ],
    ),

              const SizedBox(height: 20),
              ElevatedButton(
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
                child: const Text(AppStrings.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}