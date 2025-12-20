import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    // Warna Tema
    final Color primaryColor = const Color(0xFF004134);
    final Color accentColor = const Color(0xFFC4A484); // Warna Coklat Kopi

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- BAGIAN HEADER & KARTU MEMBER ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Background Hijau Melengkung
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Profil Saya",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Kelola akun dan preferensi Anda",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Kartu Profil Mengambang
                Positioned(
                  top: 130, // Posisi agar menumpuk separuh
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Obx(() => CircleAvatar(
                          radius: 35,
                          backgroundColor: accentColor,
                          child: Text(
                            controller.initial.value,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        const SizedBox(width: 16),
                        // Info Teks
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                controller.name.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                controller.email.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              const SizedBox(height: 8),
                              // Badge Member
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Gold Member",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon Edit
                        IconButton(
                          onPressed: () {
                            // TODO: Ke halaman Edit Profile
                            Get.snackbar("Info", "Fitur Edit Profil akan segera hadir");
                          },
                          icon: Icon(Icons.edit_outlined, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Spacer karena ada Stack yang menumpuk
            const SizedBox(height: 80),

            // --- BAGIAN STATISTIK (Agar tidak kosong) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard("Poin Saya", "${controller.points.value}", Icons.stars, Colors.amber),
                  const SizedBox(width: 15),
                  _buildStatCard("Voucher", "${controller.voucherCount.value} Ada", Icons.confirmation_number, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- BAGIAN MENU PENGATURAN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Akun",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuTile(Icons.location_on_outlined, "Alamat Tersimpan", () {}),
                  _buildMenuTile(Icons.payment_outlined, "Metode Pembayaran", () {}),
                  _buildMenuTile(Icons.lock_outline, "Ganti Password", () {}),

                  const SizedBox(height: 25),

                  const Text(
                    "Info Lainnya",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuTile(Icons.help_outline, "Pusat Bantuan", () {}),
                  _buildMenuTile(Icons.privacy_tip_outlined, "Kebijakan Privasi", () {}),
                  _buildMenuTile(Icons.star_rate_outlined, "Beri Rating Aplikasi", () {}),

                  const SizedBox(height: 30),

                  // --- TOMBOL LOGOUT ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Dialog Konfirmasi Logout
                        Get.defaultDialog(
                          title: "Logout",
                          middleText: "Apakah Anda yakin ingin keluar?",
                          textConfirm: "Ya, Keluar",
                          textCancel: "Batal",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () {
                            Get.back(); // Tutup dialog
                            controller.logout();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Keluar Aplikasi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Versi Aplikasi 1.0.0",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER STATISTIK ---
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER MENU TILE ---
  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // box shadow tipis
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0,2))
        ]
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF004134), size: 22),
        ),
        title: Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ),
    );
  }
}