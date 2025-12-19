import 'package:coffe_shop_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/presentation/home_page.dart';
import '../controllers/order_status_controller.dart';

class OrderStatusPage extends StatefulWidget {
  final int tableNumber;
  const OrderStatusPage({super.key, required this.tableNumber});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage>
    with SingleTickerProviderStateMixin {
  
  late OrderStatusController controller;
  late AnimationController _animController;

  // Warna Tema
  final Color darkGreen = const Color(0xFF004134);
  final Color bgBrown = const Color(0xFFC4A484);
  final Color inactiveBrown = const Color(0xFFD4B89C);

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Controller Realtime
    controller = Get.put(OrderStatusController(tableNumber: widget.tableNumber));

    // ANIMASI LOOPING (0.0 sampai 1.0 terus menerus)
    // Durasi 2 detik per loop agar terlihat seperti 'loading'
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), 
    )..repeat(); // <--- KUNCI: repeat() membuat animasi berulang terus
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER HIJAU
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon berubah sesuai status (Reactive)
                Obx(() {
                  IconData icon = Icons.receipt_long;
                  if (controller.currentStatus.value == 'processing') icon = Icons.coffee_maker;
                  if (controller.currentStatus.value == 'completed') icon = Icons.check_circle;
                  
                  return Icon(icon, color: Colors.white, size: 64);
                }),
                const SizedBox(height: 16),
                const Text(
                  "Status Pesanan",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Meja ${widget.tableNumber}",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // TRACKER AREA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Live Tracking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // Panggil Widget Animasi
                _buildLiveTracker(),
              ],
            ),
          ),

          const Spacer(),

          // TOMBOL KEMBALI (Hanya aktif jika sudah selesai, opsional)
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.dashboard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Kembali ke Menu",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTracker() {
    // Kita bungkus dengan Obx agar UI rebuild saat status di database berubah
    return Obx(() {
      String status = controller.currentStatus.value;
      
      return AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          double animValue = _animController.value; // Nilai 0.0 s/d 1.0 (Looping)

          return Column(
            children: [
              // BARIS PROGRESS BAR
              Row(
                children: [
                  // TAHAP 1: PENDING / PESANAN
                  _buildSegment(
                    isActive: status == 'pending', // Sedang animasi?
                    isCompleted: status == 'processing' || status == 'completed', // Sudah lewat?
                    animValue: animValue,
                    isFirst: true,
                  ),
                  const SizedBox(width: 8),
                  
                  // TAHAP 2: PROCESSING / SEDANG DISIAPKAN
                  _buildSegment(
                    isActive: status == 'processing',
                    isCompleted: status == 'completed',
                    animValue: animValue,
                  ),
                  const SizedBox(width: 8),
                  
                  // TAHAP 3: COMPLETED / SIAP DIANTAR
                  _buildSegment(
                    isActive: status == 'completed',
                    isCompleted: false, // Tahap terakhir tidak ada "lewat"
                    animValue: animValue,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // LABEL TEKS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Pesanan", status == 'pending' || status == 'processing' || status == 'completed'),
                  _buildLabel("Sedang Disiapkan", status == 'processing' || status == 'completed'),
                  _buildLabel("Siap Diantar", status == 'completed'),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildSegment({
    required bool isActive,      // Apakah animasi sedang berjalan di sini?
    required bool isCompleted,   // Apakah tahap ini sudah selesai?
    required double animValue,   // Nilai animasi 0-1
    bool isFirst = false,
    bool isLast = false,
  }) {
    double fillFactor;

    if (isCompleted) {
      fillFactor = 1.0; // Penuh statis (Hijau full)
    } else if (isActive) {
      fillFactor = animValue; // Bergerak looping (0 -> 1 -> 0 -> 1)
    } else {
      fillFactor = 0.0; // Kosong (Cokelat)
    }

    BorderRadius borderRadius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(10) : Radius.zero,
      right: isLast ? const Radius.circular(10) : Radius.zero,
    );

    return Expanded(
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: inactiveBrown,
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: fillFactor, 
              child: Container(
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isActive) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}