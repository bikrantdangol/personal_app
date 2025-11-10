import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      appBar: AppBar(
        title: const Text('Add User',),
        backgroundColor: Colors.blue
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Add New User",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Name"),
                    validator: (value) => value!.isEmpty ? 'Name required' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Email"),
                    validator: (value) => value!.isEmpty ? 'Email required' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: _inputDecoration("Password"),
                    validator: (value) => value!.isEmpty ? 'Password required' : null,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _role,
                    dropdownColor: const Color(0xFF1B2C45),
                    decoration: _inputDecoration("Role"),
                    items: ['user', 'admin'].map((role) =>
                        DropdownMenuItem(
                          value: role,
                          child: Text(role, style: const TextStyle(color: Colors.white)),
                        )).toList(),
                    onChanged: (value) => setState(() => _role = value!),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          final user = UserModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            email: _emailController.text.trim(),
                            role: _role,
                            name: _nameController.text.trim(),
                          );

                          final String password = await UserRepository()
                              .addUser(user, _passwordController.text.trim());

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User Added\nPassword: $password")),
                          );

                          //  Navigate to Admin Dashboard
                          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🎨 Common decoration for text fields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
