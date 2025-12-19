import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/presentation/home_page.dart';

class OrderStatusPage extends StatefulWidget {
  final int tableNumber;
  const OrderStatusPage({super.key, required this.tableNumber});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage>
    with SingleTickerProviderStateMixin {
  // Warna sesuai tema KEKO
  final Color darkGreen = const Color(0xFF004134);
  final Color bgBrown = const Color(0xFFC4A484);
  final Color inactiveBrown = const Color(0xFFD4B89C); // Warna cokelat lebih terang untuk yang belum aktif

  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // --- SETUP ANIMASI DEMO ---
    // Kita set durasi 10 detik untuk simulasi dari tahap 1 sampai selesai tahap 3.
    // Total nilai 3.0 merepresentasikan 3 tahap penuh.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), 
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Mulai animasi segera setelah halaman dibuka
    _controller.forward();
    // --------------------------
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER HIJAU (Sama seperti sebelumnya)
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
                const Icon(Icons.check_circle, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Pesanan Diterima!",
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

          // BAGIAN STATUS TRACKER BERANIMASI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Status Pesanan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // WIDGET UTAMA ANIMASI TRACKER
                _buildAnimatedTracker(),
              ],
            ),
          ),

          const Spacer(),

          // TOMBOL KEMBALI
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const HomePage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Pesan Lagi / Kembali ke Menu",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun keseluruhan tracker (Baris bar + Baris Teks)
  Widget _buildAnimatedTracker() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        // Nilai saat ini (0.0 sampai 3.0)
        double currentValue = _progressAnimation.value;

        return Column(
          children: [
            // BARIS PROGRESS BAR
            Row(
              children: [
                // Tahap 1: Pesanan (Index 0)
                _buildAnimatedBarSegment(index: 0, currentValue: currentValue, isFirst: true),
                const SizedBox(width: 8),
                // Tahap 2: Sedang Disiapkan (Index 1)
                _buildAnimatedBarSegment(index: 1, currentValue: currentValue),
                const SizedBox(width: 8),
                // Tahap 3: Siap Diantar (Index 2)
                _buildAnimatedBarSegment(index: 2, currentValue: currentValue, isLast: true),
              ],
            ),
            const SizedBox(height: 12),
            // BARIS LABEL TEKS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStageLabel("Pesanan", currentValue >= 0.5), // Aktif jika progress > 0.5
                _buildStageLabel("Sedang Disiapkan", currentValue >= 1.5),
                _buildStageLabel("Siap Diantar", currentValue >= 2.5),
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget untuk membangun SATU segmen bar yang bisa terisi
  Widget _buildAnimatedBarSegment({
    required int index,
    required double currentValue,
    bool isFirst = false,
    bool isLast = false,
  }) {
    // Logika inti: Menghitung seberapa penuh bar ini berdasarkan nilai total.
    // Contoh: jika currentValue = 1.5 (tengah-tengah tahap 2).
    // Untuk index 0: (1.5 - 0).clamp(0,1) = 1.0 (Penuh)
    // Untuk index 1: (1.5 - 1).clamp(0,1) = 0.5 (Setengah Penuh)
    // Untuk index 2: (1.5 - 2).clamp(0,1) = 0.0 (Kosong)
    double fillPercentage = (currentValue - index).clamp(0.0, 1.0);

    BorderRadius borderRadius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(10) : Radius.zero,
      right: isLast ? const Radius.circular(10) : Radius.zero,
    );

    return Expanded(
      child: Container(
        height: 12,
        // Background (warna cokelat terang / belum aktif)
        decoration: BoxDecoration(
          color: inactiveBrown,
          borderRadius: borderRadius,
        ),
        // Stack untuk menumpuk warna hijau di atasnya
        child: Stack(
          children: [
            // Widget yang lebarnya berubah sesuai fillPercentage
            FractionallySizedBox(
              widthFactor: fillPercentage, // Kunci animasinya disini
              child: Container(
                decoration: BoxDecoration(
                  color: darkGreen, // Warna hijau aktif
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageLabel(String text, bool isActive) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}