import 'package:get/get.dart';
import '../../../services/cart_service.dart';

class CartController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    items.assignAll(CartService.getItems());
  }

  Future<void> addToCart({
    required String menuId,
    required String name,
    required int price,
  }) async {
    await CartService.addItem({
      'menuId': menuId,
      'name': name,
      'price': price,
    });
    loadCart(); // refresh dari Hive
  }

  Future<void> clearCart() async {
    await CartService.clear();
    loadCart();
  }
}
