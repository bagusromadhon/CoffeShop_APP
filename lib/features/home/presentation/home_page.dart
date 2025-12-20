import 'package:coffe_shop_app/features/auth/controllers/auth_controller.dart';
import 'package:coffe_shop_app/features/home/presentation/all_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../controllers/home_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/menu_item_model.dart';
import '../../cart/controllers/cart_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF004134);
    const cream = Color(0xFFF6EEDF);
    const sand = Color(0xFFD2B187); // background coklat

    final cartC = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : null;

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

                    // greet dari HomeController
                    Obx(() {
                      final authC = Get.find<AuthController>();
                      final email = authC.userEmail.value;
                      final displayUsername = email.isNotEmpty ? email.split('@')[0] : "Pelanggan";

                      return Text(
                        'Welcome, $displayUsername',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                    const SizedBox(height: 8),

                    // Search bar
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: 'Search',
                    //     filled: true,
                    //     fillColor: cream,
                    //     prefixIcon: const Icon(Icons.search),
                    //     suffixIcon: IconButton(
                    //       icon: const Icon(Icons.close),
                    //       onPressed: () {},
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //       horizontal: 16,
                    //       vertical: 0,
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(24),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    // ),
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
                            'assets/images/hero_keko.png',
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
                           // Navigasi ke menu atau tab pesanan
                        },
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== KENAPA HARUS KEKO (DESAIN BARU) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section yang lebih manis
                    Row(
                      children: [
                        Container(
                          width: 4, 
                          height: 24,
                          decoration: BoxDecoration(
                            color: darkGreen, // Menggunakan warna tema
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Kenapa Harus Keko?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkGreen, // Warna teks Hijau Tua biar kontras di Sand
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),

                    // Grid dengan Tampilan Baru
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.2, 
                      children: const [
                        _FeatureCard(
                          text: 'Biji Pilihan',
                          icon: Icons.coffee_rounded,
                        ),
                        _FeatureCard(
                          text: 'Barista Pro',
                          icon: Icons.person_pin_circle_rounded,
                        ),
                        _FeatureCard(
                          text: 'Saji Cepat',
                          icon: Icons.timer_outlined,
                        ),
                        _FeatureCard(
                          text: 'Dibuat Tulus',
                          icon: Icons.favorite_border_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== PALING POPULER (HORIZONTAL) =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Paling Populer 🔥",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Horizontal Scroll
              SizedBox(
                height: 220,
                child: Obx(() {
                  if (controller.popularMenu.isEmpty) {
                    return const Center(child: Text("Belum ada data penjualan"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.popularMenu.length,
                    itemBuilder: (context, index) {
                      return _PopularMenuCard(menu: controller.popularMenu[index]);
                    },
                  );
                }),
              ),

              // ===== SEMUA MENU (HEADER) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Menu Kami",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const AllMenuPage()),
                      child: const Text(
                        "Lihat Semua",
                        style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== LIST SEMUA MENU =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  // Loading
                  if (controller.isMenuLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Error
                  if (controller.menuError.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.menuError,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            controller.loadMenus();
                          },
                          child: const Text(
                            'Coba lagi',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  }

                  // Kosong
                  if (controller.menus.isEmpty) {
                    return const Text(
                      'Belum ada menu. Tambahkan dari Supabase atau dari halaman admin.',
                      style: TextStyle(fontSize: 12),
                    );
                  }

                  // Data Ada
                  return Column(
                    children: controller.menus.map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MenuCard(menu: m),
                      );
                    }).toList(),
                  );
                }),
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

// --- WIDGET BARU: Feature Card (Pengganti ReasonCard) ---
class _FeatureCard extends StatelessWidget {
  final String text;
  final IconData icon;

  const _FeatureCard({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna tema Keko
    const darkGreen = Color(0xFF004134); 
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // Background sedikit transparan gelap biar elegan di atas Sand
        color: darkGreen.withOpacity(0.05), 
        // Border tipis
        border: Border.all(color: darkGreen.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: darkGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: darkGreen, // Teks Hijau Tua
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItemModel menu;
  const _MenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();
    const cream = Color(0xFFF6EEDF);

    return Container(
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // GAMBAR DINAMIS
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 64,
              width: 64,
              child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                  ? Image.network(
                      menu.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/menu_keko1.png',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/menu_keko1.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // TEXT (NAMA, DESKRIPSI, HARGA)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  menu.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${menu.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // TOMBOL ADD TO CART
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF004134)),
            onPressed: () {
              cartC.addToCart(
                menuId: menu.id,
                name: menu.name,
                price: menu.price,
                imageUrl: menu.imageUrl,
              );
              Get.snackbar(
                'Berhasil',
                '${menu.name} ditambahkan',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white70,
                duration: const Duration(seconds: 1),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PopularMenuCard extends StatelessWidget {
  final MenuItemModel menu;
  const _PopularMenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Menu dengan Badge Best Seller
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                    ? Image.network(
                        menu.imageUrl!,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(height: 110, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                      )
                    : Container(height: 110, color: Colors.grey[300]),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        "Best Seller",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Informasi Menu & Tombol Tambah
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  menu.category ?? "Coffee",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rp ${menu.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004134),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartC.addToCart(
                          menuId: menu.id,
                          name: menu.name,
                          price: menu.price,
                          imageUrl: menu.imageUrl,
                        );
                        Get.snackbar(
                          'Berhasil',
                          '${menu.name} ditambahkan',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white70,
                          duration: const Duration(seconds: 1),
                        );
                      },
                      child: const Icon(
                        Icons.add_shopping_cart, 
                        color: Color(0xFF004134), 
                        size: 22
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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