import 'package:flutter/material.dart';
import '../core/middleware/auth_middleware.dart';
import '../views/auth/login_screen.dart';

class RouteGuard {
  static Route<dynamic> guard({
    required WidgetBuilder builder,
    required String requiredRole,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        if (!AuthMiddleware.isLoggedIn()) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: AuthMiddleware.loadUserRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = AuthMiddleware.getUserRole();

            if (role != requiredRole) {
              return const LoginScreen();
            }

            return builder(context);
          },
        );
      },
    );
  }
}
