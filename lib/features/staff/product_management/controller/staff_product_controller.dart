import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final descC = TextEditingController();
  final imageUrlC = TextEditingController();
  
  var selectedCategory = 'Coffee'.obs;
  final List<String> categories = ['Coffee', 'Non coffee', 'Food', 'Snack'];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('menu_items')
          .select()
          .order('created_at', ascending: false);
      products.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error Fetch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- ADD PRODUCT ---
  Future<void> addProduct() async {
    if (nameC.text.isEmpty || priceC.text.isEmpty) {
      Get.snackbar("Error", "Nama dan Harga wajib diisi");
      return;
    }

    // Parsing harga aman
    int? parsedPrice = int.tryParse(priceC.text.replaceAll(RegExp(r'[^0-9]'), '')); 
    if (parsedPrice == null) {
      Get.snackbar("Error", "Harga harus berupa angka");
      return;
    }

    try {
      isLoading.value = true;
      await Supabase.instance.client.from('menu_items').insert({
        'name': nameC.text,
        'price': parsedPrice,
        'category': selectedCategory.value,
        'description': descC.text,
        'image_url': (imageUrlC.text.isEmpty || !imageUrlC.text.startsWith('http'))
            ? 'https://via.placeholder.com/150' 
            : imageUrlC.text,
      });

      Get.back();
      Get.snackbar("Sukses", "Menu berhasil ditambahkan");
      fetchProducts();
      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- UPDATE (GANTI TIPE PARAMETER JADI DYNAMIC) ---
  Future<void> updateProduct(dynamic id) async { // <--- Ubah int jadi dynamic
    int? parsedPrice = int.tryParse(priceC.text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsedPrice == null) {
      Get.snackbar("Error", "Harga harus berupa angka valid");
      return;
    }

    try {
      isLoading.value = true;
      await Supabase.instance.client.from('menu_items').update({
        'name': nameC.text,
        'price': parsedPrice,
        'category': selectedCategory.value,
        'description': descC.text,
        'image_url': (imageUrlC.text.isEmpty || !imageUrlC.text.startsWith('http'))
            ? 'https://via.placeholder.com/150' 
            : imageUrlC.text,
      }).eq('id', id); 

      Get.back(); 
      Get.back(); 
      Get.snackbar("Sukses", "Menu berhasil diperbarui");
      fetchProducts();
      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Gagal update menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- DELETE (GANTI TIPE PARAMETER JADI DYNAMIC) ---
  Future<void> deleteProduct(dynamic id) async { // <--- Ubah int jadi dynamic
    try {
      await Supabase.instance.client.from('menu_items').delete().eq('id', id);
      fetchProducts();
      Get.back();
      Get.snackbar("Sukses", "Menu berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus: $e");
    }
  }

  void clearForm() {
    nameC.clear();
    priceC.clear();
    descC.clear();
    imageUrlC.clear();
    selectedCategory.value = 'Coffee';
  }

  void fillForm(Map<String, dynamic> item) {
    nameC.text = item['name'] ?? '';
    // Pakai toString() agar aman walaupun dari DB bentuknya int atau string
    priceC.text = (item['price'] ?? 0).toString(); 
    descC.text = item['description'] ?? '';
    imageUrlC.text = item['image_url'] ?? '';
    selectedCategory.value = item['category'] ?? 'Coffee';
  }
}