import 'package:hive_flutter/hive_flutter.dart';

class CartService {
  static Box get _box => Hive.box('cart');

  // ambil semua item cart sebagai List<Map<String, dynamic>>
  static List<Map<String, dynamic>> getItems() {
    return _box.values
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  static Future<void> addItem(Map<String, dynamic> item) async {
    await _box.add(item);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}
