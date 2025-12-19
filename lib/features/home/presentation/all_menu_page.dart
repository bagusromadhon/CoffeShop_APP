import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/menu_item_model.dart';
import '../../cart/controllers/cart_controller.dart';

class AllMenuPage extends GetView<HomeController> {
  const AllMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4A484), // Latar Cokelat
      appBar: AppBar(
        title: const Text('Semua Menu'),
        backgroundColor: const Color(0xFF004134), // Hijau KEKO
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. BAGIAN FILTER KATEGORI (Horizontal Scroll)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Row(
                children: [
                  _categoryButton('All'),
                  _categoryButton('Coffee'),
                  _categoryButton('Non coffee'),
                  _categoryButton('Food'),
                  _categoryButton('Snack'), 
                ],
              )),
            ),
          ),

          // 2. BAGIAN GRID MENU (Menggunakan filteredMenu)
          Expanded(
            child: Obx(() {
              // Cek loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              
              // Cek jika hasil filter kosong
              if (controller.filteredMenu.isEmpty) {
                return const Center(
                  child: Text(
                    "Menu tidak ditemukan", 
                    style: TextStyle(color: Colors.white)
                  )
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72, 
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                // Gunakan filteredMenu, bukan allMenu
                itemCount: controller.filteredMenu.length,
                itemBuilder: (context, index) {
                  return _GridMenuCard(menu: controller.filteredMenu[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Tombol Kategori
  Widget _categoryButton(String category) {
    bool isSelected = controller.selectedCategory.value == category;
    
    return GestureDetector(
      onTap: () => controller.filterByCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004134) : Colors.white,
          borderRadius: BorderRadius.circular(20), // Sedikit membulat
          border: isSelected ? null : Border.all(color: Colors.white),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF004134),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Widget Kartu Menu 
class _GridMenuCard extends StatelessWidget {
  final MenuItemModel menu;
  const _GridMenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar & Rating
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                        ? Image.network(
                            menu.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey[200]),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        SizedBox(width: 4),
                        Text(
                          "4.8", 
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Info Menu
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  menu.description ?? "Classic",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rp ${menu.price}",
                      style: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartC.addToCart(
                          menuId: menu.id,
                          name: menu.name,
                          price: menu.price,
                          imageUrl: menu.imageUrl,
                        );
                        Get.snackbar("Berhasil", "${menu.name} masuk keranjang", 
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 1000),
                          backgroundColor: Colors.white70
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004134),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}