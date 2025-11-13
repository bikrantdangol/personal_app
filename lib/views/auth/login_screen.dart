import 'package:flutter/material.dart';
import 'package:personal_app/core/utils/biometric_auth_service.dart';
import 'package:personal_app/recycle/common/shared_pref.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../viewmodels/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isSecure = true;
  bool isBiometricEnable = false; 

  final auth  = BiometricAuthService.instance;

  @override
  void initState() {
    super.initState();
   

   biometricCheck();
    
    
  }

  Future<void> biometricCheck() async{

    final value = SharedPrefService.getUserEmail().toString().isNotEmpty;
    final biomtetric =await  auth.isBiometricAvailable;
    setState(() {
      if(value && !biomtetric){
        isBiometricEnable = true;
      }
     
    });
  } 

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Logo with modern styling
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/image.png',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                
                const Text(
                  "Welcome to the Devnasoft",
                  style: TextStyle(
                    color: Color(0xFF1a1a1a),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  "Login to continue to Devnasoft",
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),
                
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
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Color(0xFF1a1a1a)),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
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
                        ),
                        validator: Validators.validateEmail,
                      ),

                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _passwordController,
                        obscureText: isSecure,
                        style: const TextStyle(color: Color(0xFF1a1a1a)),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          suffixIcon: InkWell(
                             onTap: (){

                              
                                    setState(() {
                                        isSecure = !isSecure;
            
                                      });
                             },
                            
                            child: Icon(isSecure ? Icons.visibility : Icons.visibility_off, color: Colors.grey.shade600)),
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
                        ),
                        validator: Validators.validatePassword,
                      ),
                      
                      const SizedBox(height: 24),
            
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading ? null : () async {
                            try {
                              await authVM.login(_emailController.text.trim(), _passwordController.text.trim());
                               if(authVM.user != null){
                                 await SharedPrefService.setUserEmail(_emailController.text.trim());
                                 await SharedPrefService.setUserPasswordl(_passwordController.text.trim());

                               }
                              if (authVM.user != null && authVM.user?.email == "dangolbikrant3@gmail.com") {
                                Navigator.pushReplacementNamed(context, '/adminDashboard');
                              } else if (authVM.role != null && authVM.role == 'user') {
                                Navigator.pushReplacementNamed(context, '/userDashboard');
                              } else if (authVM.role != null && authVM.role == 'admin') {
                                Navigator.pushReplacementNamed(context, '/adminDashboard');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Login failed!")),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
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
                          child: authVM.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(isBiometricEnable)
                InkWell(
                  onTap: ()async{
                        if(isBiometricEnable){
                          await authVM.login(_emailController.text.trim(), _passwordController.text.trim());
                        }
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    
                    
                    child: Icon(Icons.fingerprint, size: 36,),
                    
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