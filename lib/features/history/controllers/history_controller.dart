import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryController extends GetxController {
  
  // Stream untuk mengambil riwayat pesanan user ini saja
  Stream<List<Map<String, dynamic>>> getHistoryStream() {
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user == null) {
      return Stream.value([]); // Return list kosong jika tidak login
    }

    return Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id) // <--- FILTER PENTING: Hanya data user ini
        .order('created_at', ascending: false) // Yang terbaru di atas
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // Helper Warna Status
  int getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return 0xFFFF9800;    // Orange
      case 'PROCESSING': return 0xFF2196F3; // Biru
      case 'READY': return 0xFF4CAF50;      // Hijau
      case 'COMPLETED': return 0xFF9E9E9E;  // Abu-abu
      default: return 0xFF000000;
    }
  }

  // Helper Label Status
  String getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return 'Menunggu Konfirmasi';
      case 'PROCESSING': return 'Sedang Disiapkan';
      case 'READY': return 'Siap Diantar/Diambil';
      case 'COMPLETED': return 'Selesai';
      default: return status;
    }
  }
}