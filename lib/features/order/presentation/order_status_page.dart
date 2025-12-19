import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/presentation/home_page.dart'; // Pastikan path benar

class OrderStatusPage extends StatelessWidget {
  final int tableNumber;
  const OrderStatusPage({super.key, required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    const Color darkGreen = Color(0xFF004134);
    const Color bgBrown = Color(0xFFC4A484);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Hijau Melengkung
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Pembayaran Berhasil!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Meja $tableNumber",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),

          // Timeline Status (Simulasi)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                _buildStep(true, "Pesanan Diterima", "Pembayaran terverifikasi"),
                _buildLine(true),
                _buildStep(true, "Sedang Disiapkan", "Barista sedang meracik kopi"),
                _buildLine(false),
                _buildStep(false, "Siap Diantar", "Tunggu sebentar lagi..."),
              ],
            ),
          ),

          const Spacer(),

          // Tombol Kembali ke Home
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const HomePage()), // Kembali ke Home & Reset Route
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Pesan Lagi / Kembali ke Menu", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isActive, String title, String subtitle) {
    return Row(
      children: [
        Icon(
          isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: isActive ? const Color(0xFF004134) : Colors.grey,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
      height: 30,
      width: 2,
      color: isActive ? const Color(0xFF004134) : Colors.grey[300],
    );
  }
}