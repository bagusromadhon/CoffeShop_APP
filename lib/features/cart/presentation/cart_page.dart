import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              controller.clearCart();
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(
            child: Text('Cart masih kosong 😶'),
          );
        }

        // hitung total harga
        final total = controller.items.fold<int>(
          0,
          (sum, item) => sum + (item['price'] as int),
        );

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: controller.items.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return ListTile(
                    leading: const Icon(Icons.local_cafe),
                    title: Text(item['name'] ?? ''),
                    subtitle: Text('Rp ${item['price']}'),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    'Rp $total',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
