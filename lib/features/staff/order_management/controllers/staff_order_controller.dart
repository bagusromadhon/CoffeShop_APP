import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffOrderController extends GetxController {
  // Stream untuk mengambil data pesanan secara Real-time
  Stream<List<Map<String, dynamic>>> getOrderStream() {
    return Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false) // Pesanan baru di atas
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // --- LOGIKA PERUBAHAN STATUS ---
  Future<void> advanceStatus(int orderId, String currentStatus) async {
    String nextStatus = '';

    // Tentukan status berikutnya berdasarkan status sekarang
    switch (currentStatus) {
      case 'pending':
        nextStatus = 'processing'; // Masuk dapur
        break;
      case 'processing':
        nextStatus = 'ready'; // Selesai masak, siap antar
        break;
      case 'ready':
        nextStatus = 'completed'; // Sudah diantar/bayar
        break;
      default:
        return; // Sudah selesai, tidak ada aksi
    }

    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': nextStatus})
          .eq('id', orderId);

      Get.snackbar("Update", "Status berhasil diubah ke $nextStatus");
    } catch (e) {
      Get.snackbar("Error", "Gagal update status: $e");
    }
  }

  // Helper untuk Label Status (Bahasa Indonesia)
  String getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pesanan Baru';
      case 'processing':
        return 'Sedang Disiapkan';
      case 'ready':
        return 'Siap Diantar';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  // Helper untuk Warna Status
  int getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return 0xFFFF9800; // Orange
      case 'processing':
        return 0xFF2196F3; // Biru
      case 'ready':
        return 0xFF4CAF50; // Hijau
      case 'completed':
        return 0xFF9E9E9E; // Abu-abu
      default:
        return 0xFF000000;
    }
  }
}
