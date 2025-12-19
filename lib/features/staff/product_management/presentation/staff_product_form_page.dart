import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/staff_product_controller.dart';

class StaffProductFormPage extends StatelessWidget {
  // Ubah int? menjadi dynamic agar support UUID (String)
  final dynamic itemId; 
  
  const StaffProductFormPage({super.key, this.itemId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffProductController>();
    final isEditing = itemId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Menu" : "Tambah Menu Baru"),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Nama
            TextField(
              controller: controller.nameC,
              decoration: const InputDecoration(
                labelText: "Nama Menu",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.coffee),
              ),
            ),
            const SizedBox(height: 16),

            // Harga
            TextField(
              controller: controller.priceC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga (Rp)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),

            // Kategori
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCategory.value,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: controller.categories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (val) => controller.selectedCategory.value = val!,
            )),
            const SizedBox(height: 16),

            // URL Gambar
            TextField(
              controller: controller.imageUrlC,
              decoration: const InputDecoration(
                labelText: "URL Gambar",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi
            TextField(
              controller: controller.descC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (isEditing) {
                          // itemId sekarang dynamic, jadi aman
                          controller.updateProduct(itemId); 
                        } else {
                          controller.addProduct();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800],
                  foregroundColor: Colors.white,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "Simpan Perubahan" : "Tambah Menu"),
              )),
            ),
          ],
        ),
      ),
    );
  }
}