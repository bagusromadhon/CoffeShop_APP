import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../services/cart_service.dart';
import '../../../services/order_service.dart';

class CartController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  
  // Variabel untuk fitur Self-Order
  var selectedTable = 1.obs; 
  var isOrdering = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // Getter total harga
  int get totalAmount {
    return items.fold(0, (sum, item) {
      final price = item['price'] ?? 0;
      final qty = item['quantity'] ?? 1;
      return sum + (price * qty as int);
    });
  }

  void loadCart() {
    items.value = CartService.getItems();
  }

  Future<void> addToCart({
    required String menuId,
    required String name,
    required int price,
    String? imageUrl,
  }) async {
    int index = items.indexWhere((item) => item['menuId'] == menuId);

    if (index != -1) {
      items[index]['quantity'] = (items[index]['quantity'] ?? 1) + 1;
      items[index] = Map<String, dynamic>.from(items[index]); // Refresh state
    } else {
      await CartService.addItem({
        'menuId': menuId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': 1,
      });
    }
    loadCart();
  }

  // --- TAMBAHAN PENTING AGAR TOMBOL MINUS (-) BERFUNGSI ---
  Future<void> decreaseQuantity(int index) async {
    final item = items[index];
    int currentQty = item['quantity'] ?? 1;

    if (currentQty > 1) {
      items[index]['quantity'] = currentQty - 1;
      items[index] = Map<String, dynamic>.from(items[index]);
      // Update juga ke penyimpanan lokal jika perlu, atau panggil loadCart()
    } else {
      // Jika sisa 1 dan ditekan minus, hapus item
      removeItem(index);
    }
  }
  // --------------------------------------------------------

  void removeItem(int index) async {
    items.removeAt(index);
    await CartService.clear();
    for (var item in items) {
      await CartService.addItem(item);
    }
    loadCart();
  }

  Future<void> clearCart() async {
    await CartService.clear();
    items.clear();
  }

  Future<void> placeOrder() async {
    if (items.isEmpty) return;

    try {
      isOrdering.value = true;
      
      await OrderService.submitOrder(
        tableNumber: selectedTable.value,
        totalPrice: totalAmount,
        items: items,
      );

      await clearCart();
      Get.offAllNamed(Routes.dashboard); 
      
      Get.snackbar(
        "Berhasil", 
        "Pesanan meja ${selectedTable.value} telah diterima dapur!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Get.theme.cardColor,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim pesanan: $e");
    } finally {
      isOrdering.value = false;
    }
  }
}