import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OrderStatusController extends GetxController {
  final int tableNumber;
  OrderStatusController({required this.tableNumber});

  var currentStatus = 'pending'.obs;
  late final RealtimeChannel _subscription;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _subscribeToOrderStatus();
  }

  void _subscribeToOrderStatus() {
    // Mendengarkan perubahan Realtime dari Supabase
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
            if (payload.newRecord.isNotEmpty) {
              final newStatus = payload.newRecord['status'] as String;
              
              // Jika status berubah, update UI dan bunyikan suara
              if (newStatus != currentStatus.value) {
                currentStatus.value = newStatus;
                _triggerStatusNotification(newStatus); // <--- INI PEMICU SUARANYA
              }
            }
          },
        )
        .subscribe();
  }

  // Fungsi Membunyikan Suara Lokal di HP Customer
  Future<void> _triggerStatusNotification(String status) async {
    String title = "Status Pesanan";
    String body = "Status berubah menjadi $status";
    String channelId = "channel_processing"; // Default

    // Logika Pemilihan Suara (Harus match dengan NotificationService di main.dart)
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        title = "Pesanan Disiapkan 👨‍🍳";
        body = "Mohon tunggu sebentar...";
        channelId = "channel_processing"; 
        break;
      case 'READY':
        title = "Pesanan Siap! ☕";
        body = "Silakan ambil pesanan Anda.";
        channelId = "channel_ready"; 
        break;
      case 'COMPLETED':
        title = "Selesai 🙏";
        body = "Terima kasih!";
        channelId = "channel_completed"; 
        break;
      default:
        return; 
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId, 
      title,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  @override
  void onClose() {
    Supabase.instance.client.removeChannel(_subscription);
    super.onClose();
  }
}