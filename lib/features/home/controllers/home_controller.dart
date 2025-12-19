import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../../services/menu_service.dart';
import '../../auth/controllers/auth_controller.dart'; 

class HomeController extends GetxController {
  // Variabel data menu
  var popularMenu = <MenuItemModel>[].obs;
  var allMenu = <MenuItemModel>[].obs;
  
  // 1. Variabel Filter (YANG TADI ERROR)
  var filteredMenu = <MenuItemModel>[].obs; 
  var selectedCategory = 'All'.obs; // <-- Ini yang tadi kurang
  
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
      
      // 2. Inisialisasi filteredMenu saat awal load
      // Agar saat pertama buka halaman "All Menu", isinya tidak kosong
      filteredMenu.value = results[1]; 

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    
    if (category == 'All') {
      filteredMenu.value = allMenu;
    } else {
      filteredMenu.value = allMenu
          .where((item) => item.category?.toLowerCase() == category.toLowerCase())
          .toList();
    }
  }

  // Getters untuk UI
  bool get isMenuLoading => isLoading.value;
  String get menuError => errorMessage.value; 
  List<MenuItemModel> get menus => allMenu;
}