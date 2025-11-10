import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin_view_model.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminVM = Provider.of<AdminViewModel>(context);
    adminVM.loadUsers(); // Trigger load

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      appBar: AppBar(title: const Text('User List')),
      body: ListView.builder(
        itemCount: adminVM.users.length,
        itemBuilder: (context, index) {
          final user = adminVM.users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        onPressed: () => Navigator.pushNamed(context, '/addUser'),
        child: const Icon(Icons.add),
      ),
    );
  }
}