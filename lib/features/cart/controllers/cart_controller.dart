import 'package:get/get.dart';

class CartController extends GetxController {
  // list item di cart (sementara Map dulu, nanti bisa diganti model)
  var items = <Map<String, dynamic>>[].obs;

  void addToCart({
    required String menuId,
    required String name,
    required int price,
  }) {
    items.add({
      'menuId': menuId,
      'name': name,
      'price': price,
    });
  }

  void clearCart() {
    items.clear();
  }
}
