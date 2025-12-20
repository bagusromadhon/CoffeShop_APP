import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffOrderController extends GetxController {

  var selectedFilter = 'all'.obs; 

  void setFilter(String status) {
    selectedFilter.value = status;
  }
  

  Stream<List<Map<String, dynamic>>> getOrderStream() {
    return Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  Future<void> advanceStatus(dynamic orderId, String currentStatus) async {
    // Pastikan pakai huruf kecil untuk logic switch
    String statusNormal = currentStatus.toLowerCase(); 
    String nextStatus = '';

    switch (statusNormal) {
      case 'pending': nextStatus = 'processing'; break;
      case 'processing': nextStatus = 'ready'; break;
      case 'ready': nextStatus = 'completed'; break;
      default: return;
    }

    try {
      // Simpan ke DB sebagai Huruf Besar (Sesuai format DB Anda)
      await Supabase.instance.client
          .from('orders')
          .update({'status': nextStatus.toUpperCase()}) 
          .eq('id', orderId);
      
      Get.snackbar("Update", "Status berubah jadi $nextStatus");
    } catch (e) {
      Get.snackbar("Error", "Gagal update status: $e");
    }
  }

  // Helper UI
  String getStatusLabel(String status) {
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