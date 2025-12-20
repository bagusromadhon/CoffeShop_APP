import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // --- Definisi Warna (Sesuaikan jika Anda punya file AppColors) ---
  final Color _darkGreenColor = const Color(0xFF1B4D3E);
  final Color _beigeColor = const Color(0xFFD8B48D);
  // -----------------------------------------------------------------

  // --- Animasi Latar Belakang ---
  late Animation<Color?> _bgColorAnimation;

  // --- Animasi Logo Kuning (Fase 1) ---
  late Animation<double> _yellowScaleAnimation;
  late Animation<double> _yellowOpacityAnimation;

  // --- Animasi Logo Hijau (Fase 2) ---
  late Animation<double> _greenScaleAnimation;
  late Animation<double> _greenOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Inisialisasi Controller (Total durasi 3.5 detik)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 2. Setup Animasi menggunakan Interval (Staggered Animation)

    // FASE 1: 0% - 40% (Zoom In Logo Kuning di BG Gelap)
    _yellowScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
      ),
    );

    // FASE 2: 50% - 100% (Transisi Warna & Tukar Logo)

    // a. Background berubah dari Hijau ke Krem
    _bgColorAnimation = ColorTween(begin: _darkGreenColor, end: _beigeColor).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 1.0, curve: Curves.easeInOut),
      ),
    );

    // b. Logo Kuning memudar (Fade Out)
    _yellowOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.80, curve: Curves.easeIn),
      ),
    );

    // c. Logo Hijau muncul (Fade In)
    _greenOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.80, curve: Curves.easeIn),
      ),
    );

    // d. Logo Hijau sedikit Zoom Out saat muncul (biar dinamis)
    // Mulai dari skala 1.3 (agak besar) ke 1.0 (ukuran normal)
    _greenScaleAnimation = Tween<double>(begin: 1.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 1.0, curve: Curves.easeOut),
      ),
    );

    // 3. Listener untuk navigasi setelah animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Beri jeda sedikit sebelum pindah
        Timer(const Duration(milliseconds: 500), () {
          // PENTING: Gunakan offNamed agar user tidak bisa back ke splash screen
          Get.offNamed(Routes.authGate); 
        });
      }
    });

    // 4. Mulai Animasi
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan AnimatedBuilder agar hanya bagian ini yang di-rebuild saat animasi berjalan
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          // 1. Background Color yang berubah
          backgroundColor: _bgColorAnimation.value,
          body: Center(
            // Gunakan Stack untuk menumpuk kedua logo di posisi yang sama
            child: Stack(
              alignment: Alignment.center,
              children: [
                // --- LOGO KUNING (Akan Zoom In lalu Fade Out) ---
                FadeTransition(
                  opacity: _yellowOpacityAnimation,
                  child: Transform.scale(
                    scale: _yellowScaleAnimation.value,
                    child: Image.asset(
                      'assets/images/LogoKEKO.png', // Pastikan path benar
                      width: 150, // Sesuaikan ukuran
                    ),
                  ),
                ),

                // --- LOGO HIJAU (Akan Fade In sambil Zoom Out sedikit) ---
                FadeTransition(
                  opacity: _greenOpacityAnimation,
                  child: Transform.scale(
                    scale: _greenScaleAnimation.value,
                    child: Image.asset(
                      'assets/images/LogoKEKOHIJAU.png', // Pastikan path benar
                      width: 150, // Ukuran harus sama dengan logo kuning
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}