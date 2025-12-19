import 'package:coffe_shop_app/features/order/presentation/order_status_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../services/cart_service.dart';
import '../../../services/order_service.dart';
import '../../../services/midtrans_service.dart'; 
import '../presentation/payment_webview.dart'; 

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
      items[index] = Map<String, dynamic>.from(items[index]); 
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

  // --- Fungsi Kurangi Quantity ---
  Future<void> decreaseQuantity(int index) async {
    final item = items[index];
    int currentQty = item['quantity'] ?? 1;

    if (currentQty > 1) {
      items[index]['quantity'] = currentQty - 1;
      items[index] = Map<String, dynamic>.from(items[index]);
    } else {
      removeItem(index);
    }
  }
  
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

  // ==========================================
  // LOGIKA PEMBAYARAN MIDTRANS (FIXED)
  // ==========================================
  
  Future<void> placeOrder() async {
    if (items.isEmpty) return;

    isOrdering.value = true;

    // 1. Buat Order ID Unik
    final String orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";
    
    try {
      // 2. Minta Link Pembayaran ke Midtrans
      final String? paymentUrl = await MidtransService.getToken(
        orderId: orderId,
        grossAmount: totalAmount,
        itemDetails: {},
      );

      if (paymentUrl != null) {
        isOrdering.value = false; 
        
        // 3. Buka WebView
        Get.to(() => PaymentWebview(
          url: paymentUrl,
          onSuccess: () {
            // 4. JIKA SUKSES BAYAR -> Simpan ke Supabase
            _finalizeOrderToSupabase();
          },
        ));
      } else {
        Get.snackbar("Error", "Gagal mendapatkan link pembayaran");
        isOrdering.value = false;
      }

    } catch (e) {
      isOrdering.value = false;
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }


Future<void> _finalizeOrderToSupabase() async {
  try {
    isOrdering.value = true;
    
    // Simpan nomor meja sebelum cart di-clear
    int tableNo = selectedTable.value; 

    // 1. Simpan ke Supabase
    await OrderService.submitOrder(
      tableNumber: tableNo,
      totalPrice: totalAmount,
      items: items,
    );

    // 2. Bersihkan Keranjang
    await clearCart();
    
    // 3. NAVIGASI KE STATUS PAGE (Perubahan Disini)
    // Menggunakan Get.offAll agar user tidak bisa back ke halaman pembayaran
    Get.offAll(() => OrderStatusPage(tableNumber: tableNo)); 

    // Snackbar opsional (karena halaman status sudah cukup menjelaskan)
    /* Get.snackbar(
      "Pembayaran Berhasil!", 
      "Pesanan masuk.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    ); 
    */
    
  } catch (e) {
    Get.snackbar("Gawat", "Pembayaran sukses tapi gagal simpan data: $e");
  } finally {
    isOrdering.value = false;
  }
}
}