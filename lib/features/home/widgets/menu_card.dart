import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/menu_item_model.dart';
import '../../cart/controllers/cart_controller.dart';

class MenuCard extends StatelessWidget {
  final MenuItemModel menu;
  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();
    const cream = Color(0xFFF6EEDF);

    return Container(
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 64,
              width: 64,
              child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                  ? Image.network(menu.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.fastfood),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Rp ${menu.price}", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF004134)),
            onPressed: () {
              cartC.addToCart(
                menuId: menu.id,
                name: menu.name,
                price: menu.price,
                imageUrl: menu.imageUrl,
              );
            },
          ),
        ],
      ),
    );
  }
}