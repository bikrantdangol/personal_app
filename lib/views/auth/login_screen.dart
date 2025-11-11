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

  @override
  void initState() {
    super.initState();
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
      
SizedBox(
  width: double.infinity,
  height: 45,
  child: ElevatedButton(
    onPressed: () async {
      try{
       await   authVM.login(_emailController.text.trim(), _passwordController.text.trim());
       if(authVM.user != null &&   authVM.user?.email == "dangolbikrant3@gmail.com"){
        Navigator.pushReplacementNamed(context, '/adminDashboard');
       }
    else if (authVM.role != null && authVM.role == 'user') {
      Navigator.pushReplacementNamed(context, '/userDashboard');
    } else if(authVM.role != null && authVM.role == 'admin' ){
     Navigator.pushReplacementNamed(context, '/adminDashboard');
    }
     else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed!")),
      );
    }

      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Error: $e")),);
      }
    
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    child:  Text(
     authVM.isLoading ? "Loading..."  :  "Login",
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
