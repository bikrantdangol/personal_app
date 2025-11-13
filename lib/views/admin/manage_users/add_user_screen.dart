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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
          'Add User',
          style: TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details to add a new user to the system',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Color(0xFF1a1a1a)),
                      decoration: _inputDecoration("Full Name", Icons.person_outline),
                      validator: (value) => value!.isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Color(0xFF1a1a1a)),
                      decoration: _inputDecoration("Email Address", Icons.email_outlined),
                      validator: (value) => value!.isEmpty ? 'Email required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Color(0xFF1a1a1a)),
                      obscureText: true,
                      decoration: _inputDecoration("Password", Icons.lock_outline),
                      validator: (value) => value!.isEmpty ? 'Password required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: _inputDecoration("User Role", Icons.admin_panel_settings_outlined),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Color(0xFF1a1a1a)),
                      items: [
                        DropdownMenuItem(
                          value: 'user',
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 18, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              const Text('User'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'admin',
                          child: Row(
                            children: [
                              Icon(Icons.admin_panel_settings, size: 18, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              const Text('Admin'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _role = value!),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            
                            try {
                              final user = UserModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                email: _emailController.text,
                                role: _role,
                                name: _nameController.text,
                              );

                              await UserRepository().addUser(user, _passwordController.text.trim());

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User added successfully!"),
                                  backgroundColor: Color(0xFF4caf50),
                                ),
                              );

                              Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4caf50),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                "Create User",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600),
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4caf50), width: 2),
      ),
    );
  }
}
