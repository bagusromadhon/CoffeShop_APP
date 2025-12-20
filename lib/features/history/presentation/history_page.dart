import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_controller.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Hilangkan tombol back di menu utama
      ),
      backgroundColor: Colors.grey[50],
      
      // 1. STREAMBUILDER DI LEVEL ATAS (Ambil data sekali, bagi dua di UI)
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allOrders = snapshot.data ?? [];

          // 2. FILTER DATA MENJADI DUA LIST
          
          // List 1: Dalam Proses (Status != Completed)
          final activeOrders = allOrders.where((order) {
            final status = (order['status'] ?? '').toString().toUpperCase();
            return status != 'COMPLETED' && status != 'CANCELLED';
          }).toList();

          // List 2: Selesai (Status == Completed)
          final completedOrders = allOrders.where((order) {
            final status = (order['status'] ?? '').toString().toUpperCase();
            return status == 'COMPLETED' || status == 'CANCELLED';
          }).toList();

          // 3. TAB CONTROLLER UNTUK UI
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Bagian Tab Bar (Tombol Pilihan)
                Container(
                  color: Colors.white,
                  child: const TabBar(
                    labelColor: Color(0xFF004134), // Hijau Keko
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF004134),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: "Dalam Proses"),
                      Tab(text: "Selesai"),
                    ],
                  ),
                ),
                
                // Bagian Isi Tab (List View)
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab 1: List Pesanan Aktif
                      _buildOrderList(activeOrders, controller, isHistory: false),
                      
                      // Tab 2: List Pesanan Selesai
                      _buildOrderList(completedOrders, controller, isHistory: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER AGAR KODE RAPI (REUSABLE LIST) ---
  Widget _buildOrderList(
      List<Map<String, dynamic>> orders, 
      HistoryController controller, 
      {required bool isHistory}
  ) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.soup_kitchen, 
              size: 80, 
              color: Colors.grey[300]
            ),
            const SizedBox(height: 16),
            Text(
              isHistory ? "Belum ada riwayat pesanan" : "Tidak ada pesanan aktif",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final status = order['status'] ?? 'PENDING';
        final totalPrice = order['total_price'] ?? 0;
        final date = DateTime.parse(order['created_at']).toLocal();

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              // Navigasi ke Detail
              Get.to(() => HistoryDetailPage(order: order));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris 1: Tanggal & Badge Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(date),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      _buildStatusBadge(controller, status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Baris 2: Info Meja & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nomor Meja", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            "${order['table_number']}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Total Bayar", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(totalPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              color: Colors.brown[800]
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper Badge Warna Status
  Widget _buildStatusBadge(HistoryController controller, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(controller.getStatusColor(status)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        controller.getStatusLabel(status),
        style: TextStyle(
          color: Color(controller.getStatusColor(status)),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}