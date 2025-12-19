import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/staff_product_controller.dart';
import 'staff_product_form_page.dart';

class StaffProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const StaffProductDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Menu"),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [
          // Tombol Hapus
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: "Hapus Menu?",
                middleText:
                    "Apakah Anda yakin ingin menghapus ${item['name']}?",
                textConfirm: "Hapus",
                textCancel: "Batal",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => controller.deleteProduct(item['id']),
              );
            },
          ),
          // Tombol Edit
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              controller.fillForm(item); // Isi form dengan data lama
              Get.to(() => StaffProductFormPage(itemId: item['id']));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Besar
          Container(
  width: double.infinity,
  height: 250,
  color: Colors.grey[300],
  child: item['image_url'] != null && item['image_url'].toString().startsWith('http')
      ? Image.network(
          item['image_url'],
          fit: BoxFit.cover,
          // PENANGANAN ERROR GAMBAR
          errorBuilder: (context, error, stackTrace) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                Text("Gambar tidak valid"),
              ],
            );
          },
        )
      : const Icon(Icons.image, size: 100, color: Colors.grey),
),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['category'] ?? '-',
                      style: TextStyle(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Rp ${item['price']}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  const Text(
                    "Deskripsi:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'] ?? 'Tidak ada deskripsi.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
