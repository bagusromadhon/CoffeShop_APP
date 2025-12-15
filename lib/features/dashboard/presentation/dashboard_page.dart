import 'package:coffe_shop_app/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../home/presentation/home_page.dart';
import '../../cart/presentation/cart_page.dart'; // Kita pakai CartPage sebagai "History" sementara
import '../../settings/settings_page.dart';     // SettingsPage sebagai "Account"
import '../../location/presentation/location_page.dart';

import '../../home/controllers/home_controller.dart'; 
import '../../location/controllers/location_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller dashboard
    final controller = Get.put(DashboardController());

    // Warna sesuai tema
    const activeColor = Color(0xFF5D4037); // Coklat tua seperti di gambar icon Home
    const inactiveColor = Colors.grey;

    Get.put(HomeController());
    Get.put(LocationController());

    return Scaffold(
      // BODY: Mengatur halaman apa yang muncul di tengah
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          HomePage(),       // Index 0: Home
          CartPage(),       // Index 1: History (sementara pakai Cart)
          SettingsPage(),   // Index 2: Account (Settings)
          LocationPage(),   // Index 3: Location
        ],
      )),
      
      // BOTTOM BAR: Bagian navigasi bawah
      bottomNavigationBar: Container(
        // Memberikan efek shadow sedikit di atas agar terlihat memisah
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          // Membuat sudut atas melengkung seperti di gambar (opsional)
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        // ClipRRect agar borderRadius di atasnya bekerja memotong konten
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            
            // Styling
            backgroundColor: Colors.white,
            selectedItemColor: activeColor,   // Warna Coklat saat aktif
            unselectedItemColor: inactiveColor, // Warna abu saat tidak aktif
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed, // Wajib fixed agar 4 item sejajar rapi
            elevation: 0, // Kita pakai shadow manual di Container
            
            items: const [
              // 1. HOME
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home), // Icon tebal saat aktif
                label: 'Home',
              ),
              
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined), // Icon kertas tagihan/history
                activeIcon: Icon(Icons.receipt_long),
                label: 'History',
              ),
              
              // 3. ACCOUNT
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Account',
              ),

              // 4. LOCATION
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                activeIcon: Icon(Icons.location_on),
                label: 'Location',
              ),
            ],
          )),
        ),
      ),
    );
  }
}