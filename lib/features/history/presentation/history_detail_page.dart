import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/history_controller.dart';
import 'package:get/get.dart';

class HistoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> order;
  const HistoryDetailPage({super.key, required this.order});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  late Future<List<dynamic>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchOrderItems();
  }

  Future<List<dynamic>> _fetchOrderItems() async {
    try {
      final response = await Supabase.instance.client
          .from('order_items')
          .select('*, menu_items(name, price)') // Join ke menu_items
          .eq('order_id', widget.order['id']);
      return List<dynamic>.from(response);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // bisa pakai controller yg sama untuk helper warna/text
    final controller = Get.find<HistoryController>(); 
    final status = widget.order['status'] ?? 'PENDING';
    final totalPrice = widget.order['total_price'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Icon Besar Status
            Icon(
              _getStatusIcon(status),
              size: 60,
              color: Color(controller.getStatusColor(status)),
            ),
            const SizedBox(height: 10),
            Text(
              controller.getStatusLabel(status),
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Color(controller.getStatusColor(status)),
              ),
            ),
            const SizedBox(height: 30),

            // Struk Belanja
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rincian Item", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  
                  // Future Builder untuk Load Items
                  FutureBuilder<List<dynamic>>(
                    future: _itemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: LinearProgressIndicator());
                      }
                      
                      final items = snapshot.data ?? [];
                      if (items.isEmpty) return const Text("Item tidak ditemukan");

                      return Column(
                        children: items.map((item) {
                          final menu = item['menu_items'] ?? {};
                          final name = menu['name'] ?? 'Menu dihapus';
                          final qty = item['quantity'] ?? 0;
                          final price = item['price'] ?? 0;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${qty}x $name"),
                                Text(NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(price * qty)),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalPrice)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return Icons.hourglass_top;
      case 'PROCESSING': return Icons.soup_kitchen;
      case 'READY': return Icons.check_circle_outline;
      case 'COMPLETED': return Icons.history;
      default: return Icons.info;
    }
  }
}