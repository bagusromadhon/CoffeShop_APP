import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class SignUpPage extends GetView<AuthController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF004134);
    const cream = Color(0xFFF6EEDF);
    const accentGreen = Color(0xFF004B37);

    InputDecoration _fieldDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: accentGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: accentGreen, width: 2.4),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER HIJAU + LOGO =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              decoration: const BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                  bottomRight: Radius.circular(48),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/LogoKEKO.png', // sesuaikan path
                    height: 72,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'KEKO',
                    style: TextStyle(
                      fontSize: 32,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w700,
                      color: cream,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Coffee & Eatery',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.3,
                      color: Color(0xFFD8C6A4),
                    ),
                  ),
                ],
              ),
            ),

            // ===== FORM SIGN UP =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // First Name
                    TextField(
                      controller: controller.firstNameC,
                      decoration: _fieldDecoration('First Name'),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextField(
                      controller: controller.lastNameC,
                      decoration: _fieldDecoration('Last Name'),
                    ),
                    const SizedBox(height: 16),

                    // Email.ID
                    TextField(
                      controller: controller.emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration('Email.ID'),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: controller.passC,
                      obscureText: true,
                      decoration: _fieldDecoration('Password'),
                    ),
                    const SizedBox(height: 16),

                    // Mobile No
                    TextField(
                      controller: controller.phoneC,
                      keyboardType: TextInputType.phone,
                      decoration: _fieldDecoration('Mobile No'),
                    ),

                    const SizedBox(height: 24),

                    // Join the Brew Crew button (pakai GetX)
                    Obx(
                      () => SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.signUp,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Join the Brew Crew',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Already have an account?
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.offAllNamed(Routes.login);
                        },
                        child: const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
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
}
