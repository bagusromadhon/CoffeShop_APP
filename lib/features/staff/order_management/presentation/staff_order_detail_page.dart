import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/staff_order_controller.dart';

class StaffOrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const StaffOrderDetailPage({super.key, required this.order});

  @override
  State<StaffOrderDetailPage> createState() => _StaffOrderDetailPageState();
}

class _StaffOrderDetailPageState extends State<StaffOrderDetailPage> {
  // Variable untuk menyimpan list item yang diambil dari database
  late Future<List<dynamic>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchOrderItems();
  }

  // Fungsi untuk mengambil item dari tabel 'order_items' + info dari 'menu_items'
  Future<List<dynamic>> _fetchOrderItems() async {
    try {
      final response = await Supabase.instance.client
          .from('order_items')
          // Select semua kolom order_items, DAN ambil nama/gambar dari tabel menu_items (Foreign Key)
          .select('*, menu_items(name, price, image_url)') 
          .eq('order_id', widget.order['id']);
      
      return List<dynamic>.from(response);
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffOrderController>();
    final status = widget.order['status'] ?? 'pending';
    final totalPrice = widget.order['total_price'] ?? 0;
    
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(widget.order['created_at']).toLocal();
    } catch (e) {
      createdAt = DateTime.now();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Meja ${widget.order['table_number']}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. STATUS HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(controller.getStatusColor(status)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(controller.getStatusColor(status)),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Status Saat Ini",
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.getStatusLabel(status).toUpperCase(),
                    style: TextStyle(
                      color: Color(controller.getStatusColor(status)),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // --- 2. INFORMASI WAKTU ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Waktu Pemesanan", style: TextStyle(color: Colors.grey)),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(createdAt),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 30),

            // --- 3. RINCIAN MENU (DENGAN FUTURE BUILDER) ---
            const Text("Rincian Menu", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // FutureBuilder menunggu data dari database
                  FutureBuilder<List<dynamic>>(
                    future: _itemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ));
                      }
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("Tidak ada item / Gagal memuat", style: TextStyle(color: Colors.grey)),
                        );
                      }

                      final items = snapshot.data!;

                      return Column(
                        children: items.map((item) {
                          // LOGIKA DATA RELATIONAL
                          // Data menu ada di dalam object 'menu_items'
                          final menuData = item['menu_items'] ?? {};
                          
                          final name = menuData['name'] ?? 'Menu Dihapus';
                          final qty = int.tryParse(item['quantity'].toString()) ?? 0;
                          
                          // Gunakan harga dari order_items (snapshot) jika ada, kalau null pakai harga menu saat ini
                          final priceRaw = item['price'] ?? menuData['price'] ?? 0;
                          final price = int.tryParse(priceRaw.toString()) ?? 0;
                          
                          final totalItem = price * qty;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Quantity Box
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "${qty}x",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Nama Menu
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),

                                // Harga Total per Item
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id', symbol: '', decimalDigits: 0
                                  ).format(totalItem),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  const _DashedLine(), 
                  const SizedBox(height: 12),

                  // --- 4. TOTAL HARGA ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL BAYAR", 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        "Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalPrice)}",
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.brown
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- 5. TOMBOL AKSI BAWAH ---
      bottomNavigationBar: status.toString().toLowerCase() == 'completed'
          ? null 
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.advanceStatus(widget.order['id'], status);
                  Get.back(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(controller.getStatusColor(status)),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline),
                    const SizedBox(width: 8),
                    Text(
                      _getNextActionLabel(status),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _getNextActionLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return "TERIMA PESANAN";
      case 'processing': return "SELESAI DIMASAK";
      case 'ready': return "SELESAIKAN PESANAN";
      default: return "Lanjut";
    }
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: 6.0,
              height: 1.0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}