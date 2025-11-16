import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // sebelumnya:
    // Get.lazyPut<AuthController>(() => AuthController());

    // ganti jadi permanent biar gak di-dispose tiap pindah halaman
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
