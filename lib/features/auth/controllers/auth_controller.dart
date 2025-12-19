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

  @override
  void onReady() {
    super.onReady();
    // Pengecekan otomatis saat aplikasi baru dibuka atau di-restart
    _checkAuthAndNavigate();
  }

  // --- LOGIKA UTAMA MULTI USER ---
  void _checkAuthAndNavigate() async {
    // Beri jeda sedikit agar Splash Screen (jika ada) sempat tampil
    await Future.delayed(const Duration(milliseconds: 500));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // 1. User sudah login, update session
      _refreshUserSession();
      // 2. JANGAN LANGSUNG KE DASHBOARD, CEK ROLE DULU
      await _checkRoleAndRedirect(); 
    } else {
      // 3. Jika User BELUM Login, arahkan ke Login
      Get.offAllNamed(Routes.login); 
    }
  }

  // Fungsi Baru: Cek Role ke Database Supabase
  Future<void> _checkRoleAndRedirect() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    
    // Safety check jika user null
    if (userId == null) {
      Get.offAllNamed(Routes.login);
      return;
    }

    try {
      // Query ke tabel 'users' untuk mengambil kolom 'role'
      // Pastikan Anda sudah membuat tabel 'users' di Supabase sesuai instruksi sebelumnya
      final data = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      // Ambil role, default ke 'customer' jika null
      final role = data['role'] as String? ?? 'customer';

      if (role == 'staff') {
        print("Login sebagai STAFF");
        Get.offAllNamed(Routes.staffDashboard); // Arahkan ke Dashboard Staff
      } else {
        print("Login sebagai CUSTOMER");
        Get.offAllNamed(Routes.dashboard); // Arahkan ke Dashboard Customer
      }

    } catch (e) {
      print("Error cek role: $e");
      // Fallback: Jika terjadi error (misal tabel belum dibuat),
      // default-kan ke Customer agar aplikasi tidak macet.
      Get.offAllNamed(Routes.dashboard);
    }
  }
  // ---------------------------------------------

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
      // PERUBAHAN DISINI: Panggil cek role, bukan langsung ke dashboard
      await _checkRoleAndRedirect();
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
    // AuthService.signUp seharusnya sudah handle insert ke auth.users
    // Trigger di Supabase akan otomatis mengisi tabel public.users
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

  // ========== SIGN OUT (PENTING UNTUK TEST MULTI USER) ==========
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    userEmail.value = '';
    Get.offAllNamed(Routes.login);
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