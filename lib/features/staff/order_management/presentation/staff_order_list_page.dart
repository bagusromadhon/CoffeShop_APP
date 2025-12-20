import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import '../controllers/staff_order_controller.dart';
import 'staff_order_detail_page.dart';

class StaffOrderListPage extends StatelessWidget {
  const StaffOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaffOrderController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // --- BAGIAN HEADER FILTER ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(controller, 'Semua', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip(controller, 'Baru', 'pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip(controller, 'Disiapkan', 'processing'),
                  const SizedBox(width: 8),
                  _buildFilterChip(controller, 'Siap Antar', 'ready'),
                  const SizedBox(width: 8),
                  _buildFilterChip(controller, 'Selesai', 'completed'),
                ],
              ),
            ),
          ),
          
          // --- BAGIAN LIST PESANAN ---
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.getOrderStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final allOrders = snapshot.data ?? [];

                // --- LOGIC FILTERING (Membungkus List dengan Obx) ---
                //menggunakan Obx disini agar saat tombol filter diklik, list langsung berubah
                return Obx(() {
                  // Filter data berdasarkan status yang dipilih
                  final filteredOrders = controller.selectedFilter.value == 'all'
                      ? allOrders
                      : allOrders.where((order) {
                          final status = (order['status'] ?? '').toString().toLowerCase();
                          return status == controller.selectedFilter.value;
                        }).toList();

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "Tidak ada pesanan di status ini",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final status = order['status'] ?? 'pending';
                      List<dynamic> items = order['items'] ?? [];

                      return _buildOrderCard(order, status, items, controller);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PISAHAN UNTUK TOMBOL FILTER ---
  Widget _buildFilterChip(StaffOrderController controller, String label, String value) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) controller.setFilter(value);
        },
        selectedColor: Colors.brown,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
      );
    });
  }

  // --- WIDGET KARTU PESANAN (Dipisah biar rapi) ---
Widget _buildOrderCard(
    Map<String, dynamic> order, 
    String status, 
    List<dynamic> items, 
    StaffOrderController controller) {
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      clipBehavior: Clip.antiAlias, //efek klik rapih 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell( // <--- TAMBAHKAN INKWELL DISINI
      onTap: () {
        // Navigasi ke Halaman Detail
        Get.to(() => StaffOrderDetailPage(order: order));
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meja ${order['table_number']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(controller.getStatusColor(status)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.getStatusLabel(status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            ...items.map((item) {
              final price = int.tryParse(item['price'].toString()) ?? 0;
              final qty = int.tryParse(item['quantity'].toString()) ?? 0;
              final totalItemPrice = price * qty;

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item['quantity']}x ${item['name']}", style: const TextStyle(fontSize: 15)),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
                          .format(totalItemPrice),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('HH:mm').format(DateTime.parse(order['created_at']).toLocal()),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "Total: Rp ${order['total_price']}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            
            // Tombol hanya muncul jika belum completed
            if (status.toString().toLowerCase() != 'completed') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.advanceStatus(order['id'], status),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(status),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _getButtonText(status),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ]
          ],
        ),
      )
    ),
    );
  }

  String _getButtonText(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return "Terima & Siapkan";
      case 'processing': return "Selesai Masak (Siap Antar)";
      case 'ready': return "Selesaikan Pesanan";
      default: return "";
    }
  }

  Color _getButtonColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.brown;
      case 'processing': return Colors.blue[700]!;
      case 'ready': return Colors.green[700]!;
      default: return Colors.grey;
    }
  }
}