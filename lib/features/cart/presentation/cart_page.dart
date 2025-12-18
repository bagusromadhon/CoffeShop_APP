import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => controller.clearCart(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(child: Text('Keranjang masih kosong ☕'));
        }

        return Column(
          children: [
            // LIST ITEM KERANJANG
            Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item['imageUrl'] ?? ''),
                    ),
                    title: Text(item['name']),
                    subtitle: Text('Rp ${item['price']} x ${item['quantity']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => controller.removeItem(index),
                    ),
                  );
                },
              ),
            ),

            // BAGIAN PILIH MEJA & CHECKOUT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row Pilihan Meja
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pilih Nomor Meja:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int>(
                          value: controller.selectedTable.value,
                          underline: const SizedBox(),
                          items: List.generate(15, (index) => index + 1)
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text("Meja $e"),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) controller.selectedTable.value = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Row Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Bayar:", style: TextStyle(fontSize: 18)),
                      Text(
                        "Rp ${controller.totalAmount}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tombol Pesan Sekarang
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: controller.isOrdering.value 
                        ? null 
                        : () => controller.placeOrder(),
                      child: controller.isOrdering.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("PESAN SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}