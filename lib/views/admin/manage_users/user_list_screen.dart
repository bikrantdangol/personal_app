import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin_view_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdminViewModel>(context, listen: false).fetchUsers()
    );
  }

  @override
  Widget build(BuildContext context) {
      final adminVM = Provider.of<AdminViewModel>(context);


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      appBar: AppBar(title: const Text('User List')),
      body:adminVM.isLoading
          ? const Center(child: CircularProgressIndicator()):
      
       ListView.builder(
        itemCount: adminVM.users.length,
        itemBuilder: (context, index) {
          final user = adminVM.users[index];
          return ListTile(
            title: Text(user.name, style:  TextStyle(color: Colors.white),),
            subtitle: Text(user.email , style:  TextStyle( color: Colors.white.withAlpha(200)),),
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