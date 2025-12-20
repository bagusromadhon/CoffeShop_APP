import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffOrderController extends GetxController {
  
  Stream<List<Map<String, dynamic>>> getOrderStream() {
    return Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  Future<void> advanceStatus(dynamic orderId, String currentStatus) async {
    // 1. UBAH KE HURUF KECIL DULU AGAR COCOK
    String statusNormal = currentStatus.toLowerCase(); 
    String nextStatus = '';

    print("Cek Status: $statusNormal"); // Debugging

    switch (statusNormal) {
      case 'pending':
        nextStatus = 'processing'; // Simpan sebagai huruf kecil atau besar tergantung selera, disini saya pakai kecil
        break;
      case 'processing':
        nextStatus = 'ready';
        break;
      case 'ready':
        nextStatus = 'completed';
        break;
      default:
        print("Status tidak dikenali: $statusNormal");
        return; // Ini yang bikin diam saja sebelumnya
    }

    try {
      // 2. KITA UPDATE KE DB (SAYA PAKAI HURUF BESAR AGAR KONSISTEN DENGAN DB ANDA SEKARANG)
      String statusToDb = nextStatus.toUpperCase(); 

      await Supabase.instance.client
          .from('orders')
          .update({'status': statusToDb}) // Update jadi 'PROCESSING', 'READY', dll
          .eq('id', orderId);
      
      Get.snackbar("Sukses", "Status berubah jadi $statusToDb");
    } catch (e) {
      Get.snackbar("Error", "Gagal update status: $e");
    }
  }

  String getStatusLabel(String status) {
    // Handle huruf besar/kecil di UI juga
    switch (status.toLowerCase()) {
      case 'pending': return 'Pesanan Baru';
      case 'processing': return 'Sedang Disiapkan';
      case 'ready': return 'Siap Diantar';
      case 'completed': return 'Selesai';
      default: return status;
    }
  }
  
  int getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 0xFFFF9800;    
      case 'processing': return 0xFF2196F3; 
      case 'ready': return 0xFF4CAF50;      
      case 'completed': return 0xFF9E9E9E;  
      default: return 0xFF000000;
    }
  }
}