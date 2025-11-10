import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Admin credentials
  static const String _adminEmail = 'admin@example.com';
  static const String _adminPassword = 'admin123';

  @override
  void initState() {
    super.initState();
    _emailController.text = _adminEmail;
    _passwordController.text = _adminPassword;
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 45, // circle size (adjust if needed)
                  backgroundColor: Colors.white.withOpacity(0.2), // soft border effect (optional)
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/image.png',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Welcome to the Devnasoft login page",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
                
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username or Email",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: Validators.validateEmail,
                ),

                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: Validators.validatePassword,
                ),
                
                const SizedBox(height: 25),

      //           SizedBox(
      //             width: double.infinity,
      //             height: 45,
      //             child: ElevatedButton(
      //               onPressed: authVM.isLoading
      //                   ? null
      // : () async {
      //     if (_formKey.currentState!.validate()) {
      //       final email = _emailController.text.trim();
      //       final password = _passwordController.text.trim();

      //       try {
      //         print("Credentials: $email, $password");

      //         // Check for admin credentials
      //         if (email == _adminEmail && password == _adminPassword) {
      //           Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      //           return; // Stop here so it doesn't continue to user login
      //         }

      //         // Regular user login
      //         await authVM.login(email, password);
      //         Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
      //       } catch (e) {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text(e.toString())),
      //         );
      //       }
      //     }
      //   },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.orangeAccent,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(6),
      //                 ),
      //               ),
      //               child: authVM.isLoading
      //                   ? const CircularProgressIndicator(color: Colors.white)
      //                   : const Text("Login", style: TextStyle(fontSize: 16)),
      //             ),
      //           ),
      
SizedBox(
  width: double.infinity,
  height: 45,
  child: ElevatedButton(
    onPressed: () {
      // Check static admin credentials directly
      if (_emailController.text.trim() == _adminEmail &&
          _passwordController.text.trim() == _adminPassword) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
       
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    child: const Text(
      "Login",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
  ),
),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
