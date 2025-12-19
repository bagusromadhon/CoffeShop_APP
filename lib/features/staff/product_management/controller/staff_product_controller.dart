import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffProductController extends GetxController {
  // List produk yang reaktif
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Controller untuk Form Input
  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final descC = TextEditingController();
  final imageUrlC = TextEditingController();
  
  // Variabel untuk menyimpan kategori yang dipilih
  var selectedCategory = 'Coffee'.obs;
  final List<String> categories = ['Coffee', 'Non coffee', 'Food', 'Snack'];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // --- READ (Ambil Data) ---
  void fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('menu_items')
          .select()
          .order('created_at', ascending: false);
      
      products.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat produk: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- CREATE (Tambah Data) ---
  Future<void> addProduct() async {
    if (nameC.text.isEmpty || priceC.text.isEmpty) {
      Get.snackbar("Error", "Nama dan Harga wajib diisi");
      return;
    }

    try {
      isLoading.value = true;
      await Supabase.instance.client.from('menu_items').insert({
        'name': nameC.text,
        'price': int.parse(priceC.text),
        'category': selectedCategory.value,
        'description': descC.text,
        'image_url': imageUrlC.text.isEmpty 
            ? 'https://via.placeholder.com/150' // Placeholder jika kosong
            : imageUrlC.text,
      });

      Get.back(); // Tutup halaman form
      Get.snackbar("Sukses", "Menu berhasil ditambahkan");
      fetchProducts(); // Refresh list
      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- UPDATE (Edit Data) ---
  Future<void> updateProduct(int id) async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.from('menu_items').update({
        'name': nameC.text,
        'price': int.parse(priceC.text),
        'category': selectedCategory.value,
        'description': descC.text,
        'image_url': imageUrlC.text,
      }).eq('id', id);

      Get.back(); // Tutup form
      Get.back(); // Tutup detail page (jika edit dari detail)
      Get.snackbar("Sukses", "Menu berhasil diperbarui");
      fetchProducts();
      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Gagal update menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- DELETE (Hapus Data) ---
  Future<void> deleteProduct(int id) async {
    try {
      await Supabase.instance.client.from('menu_items').delete().eq('id', id);
      fetchProducts();
      Get.back(); // Tutup dialog/halaman detail
      Get.snackbar("Sukses", "Menu berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus: $e");
    }
  }

  // Helper untuk membersihkan form
  void clearForm() {
    nameC.clear();
    priceC.clear();
    descC.clear();
    imageUrlC.clear();
    selectedCategory.value = 'Coffee';
  }

  // Helper untuk mengisi form saat mau Edit
  void fillForm(Map<String, dynamic> item) {
    nameC.text = item['name'] ?? '';
    priceC.text = (item['price'] ?? 0).toString();
    descC.text = item['description'] ?? '';
    imageUrlC.text = item['image_url'] ?? '';
    selectedCategory.value = item['category'] ?? 'Coffee';
  }
}