import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/staff_product_controller.dart';
import 'staff_product_form_page.dart';
import 'staff_product_detail_page.dart';

class StaffProductListPage extends StatelessWidget {
  const StaffProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller
    final controller = Get.put(StaffProductController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text("Belum ada menu. Tambahkan sekarang!"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final item = controller.products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    image: item['image_url'] != null
                        ? DecorationImage(
                            image: NetworkImage(item['image_url']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item['image_url'] == null
                      ? const Icon(Icons.coffee, color: Colors.brown)
                      : null,
                ),
                title: Text(item['name'] ?? 'No Name', 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Rp ${item['price']} • ${item['category']}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Ke Halaman Detail
                  Get.to(() => StaffProductDetailPage(item: item));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[800],
        onPressed: () {
          controller.clearForm();
          Get.to(() => const StaffProductFormPage());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}