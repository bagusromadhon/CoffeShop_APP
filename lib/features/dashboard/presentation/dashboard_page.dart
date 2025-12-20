import 'package:coffe_shop_app/features/history/presentation/history_page.dart';
import 'package:coffe_shop_app/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../home/presentation/home_page.dart';
import '../../cart/presentation/cart_page.dart'; 
import '../../settings/settings_page.dart'; 
import '../../location/presentation/location_page.dart';



class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller diambil via Get.find karena sudah di-init di Binding
    final controller = Get.find<DashboardController>();

    // Warna sesuai tema
    const activeColor = Color(0xFF5D4037); 
    const inactiveColor = Colors.grey;

    return Scaffold(
      // BODY: Urutan children HARUS sama dengan urutan BottomNavigationBar
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          HomePage(),       
          HistoryPage(), 
          CartPage(),  
          LocationPage(), 
          ProfilePage(),   
        ],
      )),
      
      // BOTTOM BAR
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
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
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            selectedFontSize: 11, 
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed, 
            elevation: 0,
            
            items: const [
              // 1. HOME
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
               // 2. RIWAYAT
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Riwayat',
              ),
              // 3. KERANJANG
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'Keranjang',
              ),
              // 4. LOCATION
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                activeIcon: Icon(Icons.location_on),
                label: 'Location',
              ),
              // 5. PROFILE
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),

              
            ],
          )),
        ),
      ),
    );
  }
}