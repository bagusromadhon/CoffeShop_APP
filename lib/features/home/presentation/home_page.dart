import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF004134);
    const cream = Color(0xFFF6EEDF);
    const sand = Color(0xFFD2B187); // background coklat

    return Scaffold(
      backgroundColor: sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== HEADER HIJAU + SEARCH =====
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo KEKO tulisan
                    Center(
                      child: Image.asset(
                        'assets/images/LogoTulisanKEKO.png',
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // (optional) greet dari HomeController
                    Obx(
                      () => Text(
                        'Welcome, ${controller.username.value}',
                        style: const TextStyle(
                          color: cream,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: cream,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {},
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===== HERO IMAGE + BUTTON PESAN =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/hero_keko.png', // sesuaikan dengan aset kamu
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 16,
                            bottom: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Kopi Premium KEKO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Nikmati ketenangan dengan secangkir kopi hangat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {
                          // nanti bisa buka halaman menu
                        },
                        child: const Text(
                          'Pesan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== KENAPA HARUS KEKO =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kenapa harus KEKO?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.5,
                      children: const [
                        _ReasonCard(text: 'Menggunakan biji kopi pilihan'),
                        _ReasonCard(text: 'Barista profesional'),
                        _ReasonCard(text: 'Penyajian yang cepat'),
                        _ReasonCard(text: 'Dibuat dengan hati yang tulus'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== MENU POPULER =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Menu populer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'Lihat semua',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    _MenuCard(
                      imagePath: 'assets/images/menu_keko1.png',
                      title: 'KEKO Kopi',
                      subtitle: 'Kopi gula aren',
                      price: 'Rp 20.000',
                    ),
                    SizedBox(height: 12),
                    _MenuCard(
                      imagePath: 'assets/images/menu_keko2.png',
                      title: 'KEKO Latte',
                      subtitle: 'Latte creamy manis',
                      price: 'Rp 24.000',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== HUBUNGI KAMI =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hubungi kami',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      _ContactRow(
                        icon: Icons.phone,
                        text: '+62 890-1234-1313',
                      ),
                      SizedBox(height: 8),
                      _ContactRow(
                        icon: Icons.location_on_outlined,
                        text: 'Jl. Mana Hayo No. 19',
                      ),
                      SizedBox(height: 8),
                      _ContactRow(
                        icon: Icons.camera_alt_outlined,
                        text: '@kekocoffee',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======== WIDGET KECIL2 ========

class _ReasonCard extends StatelessWidget {
  final String text;
  const _ReasonCard({required this.text});

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFF6EEDF);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;

  const _MenuCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFF6EEDF);
    return Container(
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Hot',
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
