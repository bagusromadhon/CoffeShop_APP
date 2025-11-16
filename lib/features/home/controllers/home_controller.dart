import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../../services/menu_service.dart';

class HomeController extends GetxController {
  var username = 'Guest'.obs;

  var menus = <MenuItemModel>[].obs;
  var isMenuLoading = false.obs;

  Future<void> loadMenus() async {
    try {
      isMenuLoading.value = true;
      final data = await MenuService.fetchMenu();
      menus.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat menu: $e');
    } finally {
      isMenuLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }
}
