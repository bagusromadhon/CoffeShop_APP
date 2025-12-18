import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../../services/menu_service.dart';
import '../../auth/controllers/auth_controller.dart'; // Import AuthController

class HomeController extends GetxController {
  // Variabel data menu
  var popularMenu = <MenuItemModel>[].obs;
  var allMenu = <MenuItemModel>[].obs;
  
  // State UI
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // Ambil nama user dari AuthController
  String get username {
    try {
      final authC = Get.find<AuthController>();
      // Mengambil email/nama dari authController, 
      // dipotong sebelum '@' jika yang tersedia hanya email
      String fullEmail = authC.userEmail.value;
      if (fullEmail.isEmpty) return "Pelanggan";
      return fullEmail.split('@')[0];
    } catch (e) {
      return "Pelanggan";
    }
  }

  Future<void> loadMenus() => loadData();

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        MenuService.fetchPopularMenu(),
        MenuService.fetchMenu(),
      ]);
      
      popularMenu.value = results[0];
      allMenu.value = results[1];
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Getters untuk UI
  bool get isMenuLoading => isLoading.value;
  String get menuError => errorMessage.value; // Pastikan ini String, bukan RxString
  List<MenuItemModel> get menus => allMenu;
}