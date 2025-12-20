import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../product_management/presentation/staff_product_list_page.dart'; 
import '../order_management/presentation/staff_order_list_page.dart';
import '../product_management/presentation/staff_product_list_page.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  int _selectedIndex = 0;

  // Halaman-halaman Staff
  final List<Widget> _pages = [
    const StaffOrderListPage(),
    const StaffProductListPage(),
    const Center(child: Text("Halaman Manage Order (Incoming)")), 
    const Center(child: Text("Settings / Logout")),
    const Center(child: Text("Halaman Manage Order (Incoming)")), 
    const Center(child: Text("Halaman Manage Product (Menu)")),   
    const Center(child: Text("Settings / Logout")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Area"),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Logout logic
              await Get.find<AuthController>().signOut(); // Pastikan buat fungsi signOut di controller
              Get.offAllNamed(Routes.login);
            },
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.brown[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Akun'),
        ],
      ),
    );
  }
}