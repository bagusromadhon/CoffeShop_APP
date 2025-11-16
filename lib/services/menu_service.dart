import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/menu_item_model.dart';

class MenuService {
  static final _client = Supabase.instance.client;
  static const _table = 'menu_items';

  static Future<List<MenuItemModel>> fetchMenu() async {
    final res = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addMenu({
    required String name,
    required int price,
    String? description,
    String? imageUrl,
    String? category,
  }) async {
    await _client.from(_table).insert({
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'category': category,
    });
  }

  static Future<void> deleteMenu(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
