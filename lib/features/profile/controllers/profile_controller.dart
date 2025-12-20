import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/routes/app_routes.dart';

class ProfileController extends GetxController {
  // Data User
  var email = ''.obs;
  var name = ''.obs;
  var initial = ''.obs;
  
  // Data Dummy untuk visual (Bisa dikembangkan nanti)
  var points = 150.obs;
  var voucherCount = 3.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      email.value = user.email ?? '-';
      
      // Coba ambil nama dari metadata (jika ada), kalau tidak pakai "User"
      String fullName = user.userMetadata?['name'] ?? 'Coffee Lover';
      name.value = fullName;

      // Ambil inisial huruf depan untuk avatar
      if (fullName.isNotEmpty) {
        initial.value = fullName[0].toUpperCase();
      } else {
        initial.value = 'U';
      }
    }
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // Reset semua route dan kembali ke Login
      Get.offAllNamed(Routes.login); 
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: $e");
    }
  }
}