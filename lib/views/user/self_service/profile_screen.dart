import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../viewmodels/auth_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.currentUserDetail;

    final name = user?.name ?? 'User';
    final role = user?.role ?? 'user';
    final email = user?.email ?? 'email@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 2, 68, 150),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      email.isNotEmpty ? email[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  Divider(
                    color: Colors.white.withOpacity(0.8),
                    thickness: 1.5,
                    indent: 60,
                    endIndent: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
