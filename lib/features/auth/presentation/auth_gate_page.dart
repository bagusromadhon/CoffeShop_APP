import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/routes/app_routes.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // cek session setelah frame jalan
    Future.microtask(() async {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        // user pernah login sebelumnya → langsung ke Home
        Get.offAllNamed(Routes.home);
      } else {
        // belum pernah login / session hilang → ke Login
        Get.offAllNamed(Routes.login);
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
