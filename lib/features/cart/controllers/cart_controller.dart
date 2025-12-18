import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart'; // Import Routes agar tidak error
import '../../../services/cart_service.dart';
import '../../../services/order_service.dart'; // Import OrderService yang kita buat tadi

class CartController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  
  // Variabel baru untuk fitur Self-Order
  var selectedTable = 1.obs; 
  var isOrdering = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // Getter untuk menghitung total harga secara otomatis
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
    // Cek apakah item sudah ada di keranjang
    int index = items.indexWhere((item) => item['menuId'] == menuId);

    if (index != -1) {
      // Jika ada, tambah quantity
      items[index]['quantity'] = (items[index]['quantity'] ?? 1) + 1;
      // Re-assign agar Rx list mendeteksi perubahan
      items[index] = Map<String, dynamic>.from(items[index]);
    } else {
      // Jika belum ada, tambah baru
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

  void removeItem(int index) async {
    // Hive menggunakan index untuk delete, atau hapus semua dan tulis ulang
    // Untuk kemudahan demo, kita clear dan save ulang list yang baru
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

  // FUNGSI CHECKOUT UTAMA
  Future<void> placeOrder() async {
    if (items.isEmpty) return;

    try {
      isOrdering.value = true;
      
      // Kirim ke Supabase via OrderService
      await OrderService.submitOrder(
        tableNumber: selectedTable.value,
        totalPrice: totalAmount,
        items: items,
      );

      // Bersihkan keranjang setelah sukses
      await clearCart();
      
      // Kembali ke halaman utama (Dashboard)
      Get.offAllNamed(Routes.dashboard); 
      
      Get.snackbar(
        "Berhasil", 
        "Pesanan meja ${selectedTable.value} telah diterima dapur!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim pesanan: $e");
    } finally {
      isOrdering.value = false;
    }
  }
}