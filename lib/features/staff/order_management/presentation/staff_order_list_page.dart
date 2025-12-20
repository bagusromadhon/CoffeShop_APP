import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Jangan lupa: flutter pub add intl

import '../controllers/staff_order_controller.dart';

class StaffOrderListPage extends StatelessWidget {
  const StaffOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaffOrderController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getOrderStream(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];

          // 3. Empty State
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Belum ada pesanan masuk"),
                ],
              ),
            );
          }

          // 4. List Pesanan
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final status = order['status'] ?? 'pending';

              // Parsing item JSON (karena di DB disimpan sebagai JSONB/Array)
              List<dynamic> items = order['items'] ?? [];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Meja & Status Badge
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
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

                      // List Item Menu
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item['quantity']}x ${item['name']}",
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id',
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(item['price'] * item['quantity']),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Total Harga & Waktu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(
                              DateTime.parse(order['created_at']).toLocal(),
                            ),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Total: Rp ${order['total_price']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // TOMBOL AKSI UTAMA
                      // Tombol hilang jika status sudah 'completed'
                      if (status != 'completed')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                controller.advanceStatus(order['id'], status),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getButtonColor(status),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              _getButtonText(status),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Teks Tombol Berubah Dinamis
  String _getButtonText(String status) {
    switch (status) {
      case 'pending':
        return "Terima & Siapkan";
      case 'processing':
        return "Selesai Masak (Siap Antar)";
      case 'ready':
        return "Selesaikan Pesanan";
      default:
        return "";
    }
  }

  Color _getButtonColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.brown;
      case 'processing':
        return Colors.blue[700]!;
      case 'ready':
        return Colors.green[700]!;
      default:
        return Colors.grey;
    }
  }
}
