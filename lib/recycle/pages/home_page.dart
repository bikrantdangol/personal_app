import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_app/recycle/common/shared_pref.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 
                  FutureBuilder(
                    future: SharedPrefService.getProfileImage(),
                    builder: (context, snapshot) {
                      final imgPath = snapshot.data ?? "";
                    // 
                      return CircleAvatar(
                        radius: 70,
                        backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                        backgroundImage: imgPath.isNotEmpty ? FileImage(File(imgPath)) : null,
                        child: imgPath.isEmpty
                            ? Icon(Icons.person, size: 80, color: isDark ? Colors.white : Colors.grey)
                            : null,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  FutureBuilder(
                    future: SharedPrefService.getUsername(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  FutureBuilder(
                    future: SharedPrefService.getAddress(),
                    builder: (context, data) {
                      return Text(
                        data.data ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  Divider(
                    color: textColor,
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
