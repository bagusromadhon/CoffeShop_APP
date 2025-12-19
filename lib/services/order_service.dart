import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/cart/controllers/cart_controller.dart';

class OrderService {
  static final _client = Supabase.instance.client;

  static Future<void> submitOrder({
    required int tableNumber,
    required int totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw 'User tidak terautentikasi';

      // 1. Insert ke tabel orders (Induk)
      final orderResponse = await _client.from('orders').insert({
        'user_id': userId,
        'table_number': tableNumber,
        'total_price': totalPrice,
        'status': 'PENDING',
      }).select().single();

      final orderId = orderResponse['id'];

      // 2. Siapkan data untuk order_items (Detail)
      final List<Map<String, dynamic>> orderItems = items.map((item) {
        return {
          'order_id': orderId,
          'menu_id': item['menuId'], 
          'quantity': item['quantity'] ?? 1,
          'price_at_time': item['price'],
        };
      }).toList();

      // 3. Insert bulk ke order_items
      await _client.from('order_items').insert(orderItems);
      
    } catch (e) {
      print('Error submitOrder: $e');
      rethrow;
    }
  }
}