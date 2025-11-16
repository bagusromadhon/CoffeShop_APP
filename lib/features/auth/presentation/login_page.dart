import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF004134);
    const cream = Color(0xFFF6EEDF);
    const accentGreen = Color(0xFF004B37);

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
                    'assets/images/LogoKEKO.png', // ganti sesuai path
                    height: 72,
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/LogoTulisanKEKO.png', // ganti sesuai path
                    height: 72,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // ===== ISI LOGIN (SCROLLABLE) =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email
                    const Text('Email.ID'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: accentGreen, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: accentGreen, width: 2.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    const Text('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.passC,
                      obscureText: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: accentGreen, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: accentGreen, width: 2.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: forgot password
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // NEXT button pakai GetX (Obx)
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
                              : controller.signIn,
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
                                  'NEXT',
                                  style: TextStyle(
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== teks "Belum punya akun? Sign up" =====
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Belum punya akun? "),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.signup);
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // garis + icon coffee
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        SizedBox(width: 12),
                        Icon(Icons.coffee, size: 18, color: Colors.brown),
                        SizedBox(width: 12),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // tombol Google & Facebook (dummy dulu)
                    _SocialButton(
                      text: 'Sign in with Google',
                      icon: Icons.g_mobiledata,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      text: 'Sign in with FaceBook',
                      icon: Icons.facebook,
                      onTap: () {},
                    ),

                    const SizedBox(height: 8),
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

class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentGreen = Color(0xFF004B37);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentGreen, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: accentGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
