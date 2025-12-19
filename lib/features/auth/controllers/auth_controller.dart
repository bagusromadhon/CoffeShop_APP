import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  // Variabel untuk menyimpan email user secara reaktif
  final userEmail = ''.obs; 

  // TextEditingController
  final firstNameC = TextEditingController();
  final lastNameC  = TextEditingController();
  final emailC     = TextEditingController();
  final passC      = TextEditingController();
  final phoneC     = TextEditingController();

  // state loading
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshUserSession();
  }

  // --- BAGIAN PENTING YANG HARUS DITAMBAHKAN ---
  @override
  void onReady() {
    super.onReady();
    // Pengecekan otomatis saat aplikasi baru dibuka atau di-restart
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Beri jeda sedikit agar Splash Screen (jika ada) sempat tampil
    await Future.delayed(const Duration(milliseconds: 500));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // 1. Jika User SUDAH Login (Session ada di HP)
      _refreshUserSession();
      // 2. Paksa pindah ke DASHBOARD (Halaman Induk yang punya BottomNav)
      Get.offAllNamed(Routes.dashboard); 
    } else {
      // 3. Jika User BELUM Login, arahkan ke Login
      Get.offAllNamed(Routes.login); 
    }
  }
  // ---------------------------------------------

  // Fungsi untuk menyegarkan data email user dari session Supabase
  void _refreshUserSession() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';
    }
  }

  // ========== LOGIN ==========
  Future<void> signIn() async {
    final email = emailC.text.trim();
    final pass  = passC.text;

    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Email dan password wajib diisi');
      return;
    }

    isLoading.value = true;
    final error = await AuthService.signIn(email: email, password: pass);
    isLoading.value = false;

    if (error == null) {
      _refreshUserSession(); 
      // Pindah ke Dashboard setelah login sukses
      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.snackbar('Error', error);
    }
  }

  // ========== SIGN UP ==========
  Future<void> signUp() async {
    final first = firstNameC.text.trim();
    final last  = lastNameC.text.trim();
    final email = emailC.text.trim();
    final pass  = passC.text;
    final phone = phoneC.text.trim();

    if ([first, last, email, pass, phone].any((e) => e.isEmpty)) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    isLoading.value = true;
    final error = await AuthService.signUp(
      email: email,
      password: pass,
      firstName: first,
      lastName: last,
      phone: phone,
    );
    isLoading.value = false;

    if (error == null) {
      Get.snackbar('Berhasil', 'Registrasi berhasil, silakan login.');
      Get.offAllNamed(Routes.login);
    } else {
      Get.snackbar('Error', error);
    }
  }

  @override
  void onClose() {
    firstNameC.dispose();
    lastNameC.dispose();
    emailC.dispose();
    passC.dispose();
    phoneC.dispose();
    super.onClose();
  }
}