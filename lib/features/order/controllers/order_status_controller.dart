import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderStatusController extends GetxController {
  final int tableNumber;
  OrderStatusController({required this.tableNumber});

  // Observable untuk status saat ini
  // Default 'pending' agar animasi mulai dari awal
  var currentStatus = 'pending'.obs; 
  
  // Stream subscription untuk memantau database
  late final RealtimeChannel _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToOrderStatus();
  }

  void _subscribeToOrderStatus() {
    // Mendengarkan perubahan di tabel 'orders' untuk meja yang sesuai
    // Pastikan Anda mengaktifkan 'Realtime' di dashboard Supabase untuk tabel orders
    _subscription = Supabase.instance.client
        .channel('public:orders:table_$tableNumber')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'table_number',
            value: tableNumber,
          ),
          callback: (payload) {
            // Saat ada data baru/update dari Supabase
            if (payload.newRecord.isNotEmpty) {
              final newStatus = payload.newRecord['status'] as String;
              print("Status Update dari DB: $newStatus"); // Debug log
              currentStatus.value = newStatus;
            }
          },
        )
        .subscribe();
  }

  @override
  void onClose() {
    Supabase.instance.client.removeChannel(_subscription);
    super.onClose();
  }
}