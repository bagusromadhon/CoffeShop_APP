import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgBrown = Color(0xFFC4A484); 
    const Color darkGreen = Color(0xFF004134);

    return Scaffold(
      backgroundColor: bgBrown,
      appBar: AppBar(
        backgroundColor: bgBrown,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkGreen),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Product Cart list",
          style: TextStyle(
            color: darkGreen, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. DAFTAR ITEM (List Maps)
          Expanded(
            child: Obx(() {
              if (controller.items.isEmpty) {
                return const Center(
                  child: Text("Keranjang kosong", style: TextStyle(color: Colors.white)),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  // Ambil data map
                  final item = controller.items[index];
                  
                  final name = item['name'] ?? 'Menu';
                  final price = item['price'] ?? 0;
                  final qty = item['quantity'] ?? 1;
                  final imageUrl = item['imageUrl'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade400),
                    ),
                    child: Row(
                      children: [
                        // Gambar Produk
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(imageUrl, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.coffee, color: Colors.brown),
                        ),
                        const SizedBox(width: 16),
                        
                        // Nama & Harga
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp $price",
                                style: const TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Counter (+ / -)
                        Row(
                          children: [
                            _counterButton(Icons.remove, () {
                              controller.decreaseQuantity(index);
                            }),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "$qty",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            _counterButton(Icons.add, () {
                              controller.addToCart(
                                menuId: item['menuId'],
                                name: name,
                                price: price,
                                imageUrl: imageUrl
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // 2. PANEL PEMBAYARAN (BAWAH)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Make Payment",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 120,
                      child: Divider(color: darkGreen, thickness: 2),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Ringkasan Struk
                Obx(() => Column(
                  children: controller.items.map((item) {
                    final p = item['price'] ?? 0;
                    final q = item['quantity'] ?? 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item['name']} ($q)", style: const TextStyle(color: Colors.grey)),
                          Text("Rp ${p * q}", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }).toList(),
                )),

                const Divider(),
                
                // Total Price
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "Rp ${controller.totalAmount}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                )),
                
                const SizedBox(height: 16),
                
                // Payment Channels (Static)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payment channels", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text("Edit", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Text("Cash", style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 16),

                // DROP DOWN PILIH MEJA
                const Text("Pilih Meja", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.brown.shade200),
                  ),
                  child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: controller.selectedTable.value,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_circle, color: Color(0xFF3E2723)),
                      // Generate Meja 1 - 10
                      items: List.generate(10, (index) => index + 1).map((int val) {
                        return DropdownMenuItem<int>(
                          value: val,
                          child: Text("Meja $val"),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) controller.selectedTable.value = newValue;
                      },
                    ),
                  )),
                ),

                const SizedBox(height: 24),

                // TOMBOL CONFIRM
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isOrdering.value 
                      ? null // Disable jika loading
                      : () => controller.placeOrder(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isOrdering.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: Colors.brown),
      ),
    );
  }
}