import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class HistoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> order;
  const HistoryDetailPage({super.key, required this.order});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _itemsFuture;
  
  final Color primaryColor = const Color(0xFF004134);
  final Color inactiveColor = const Color(0xFFD7C0AE);

  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchOrderItems();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _startAnimation = true;
        });
      }
    });
  }

  Future<List<dynamic>> _fetchOrderItems() async {
    try {
      final response = await Supabase.instance.client
          .from('order_items')
          .select('*, menu_items(name, price)')
          .eq('order_id', widget.order['id']);
      return List<dynamic>.from(response);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (widget.order['status'] ?? 'PENDING').toString().toUpperCase();
    final totalPrice = widget.order['total_price'] ?? 0;
    final tableNumber = widget.order['table_number'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // --- HEADER ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: _startAnimation ? 20 : 0,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  ),
                ),
                 TweenAnimationBuilder(
                   tween: Tween<double>(begin: 0.0, end: 1.0),
                   duration: const Duration(milliseconds: 800),
                   curve: Curves.elasticOut,
                   builder: (context, double val, child) => Transform.scale(scale: val, child: child),
                   child: const Icon(Icons.receipt_long, size: 60, color: Colors.white),
                 ),
                 const SizedBox(height: 10),
                 const Text(
                  "Detail Riwayat",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Meja $tableNumber",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // --- KONTEN ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TRACKING STATUS ---
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _startAnimation ? 1.0 : 0.0,
                    curve: Curves.easeIn,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Status Pesanan",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildTrackingStatus(status),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // --- RINCIAN ITEM ---
                  AnimatedTranslation(
                    startAnimation: _startAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Rincian Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(height: 24),
                          
                          FutureBuilder<List<dynamic>>(
                            future: _itemsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ));
                              }
                              
                              final items = snapshot.data ?? [];
                              if (items.isEmpty) return const Text("Item tidak ditemukan");

                              return Column(
                                children: items.map((item) {
                                  final menu = item['menu_items'] ?? {};
                                  final name = menu['name'] ?? 'Menu dihapus';
                                  final qty = int.tryParse(item['quantity'].toString()) ?? 0;
                                  
                                  dynamic rawPrice = item['price'];
                                  if (rawPrice == null || rawPrice.toString() == '0') {
                                    rawPrice = menu['price'];
                                  }
                                  final price = int.tryParse(rawPrice.toString()) ?? 0;
                                  final totalItemPrice = price * qty;
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(6)
                                          ),
                                          child: Text("${qty}x", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(child: Text(name, style: const TextStyle(fontSize: 15))),
                                        Text(
                                          NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalItemPrice),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Bayar", style: TextStyle(fontSize: 16)),
                              Text(
                                "Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalPrice)}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC TRACKING BARU ---
  Widget _buildTrackingStatus(String currentStatus) {
    int currentStep = 0;
    switch (currentStatus) {
      case 'PENDING': currentStep = 1; break;
      case 'PROCESSING': currentStep = 2; break;
      case 'READY': currentStep = 3; break;
      case 'COMPLETED': currentStep = 4; break;
      default: currentStep = 1;
    }

    return Column(
      children: [
        Row(
          children: [
            // Bar 1: Pesanan Diterima
            _TrackingBar(
              state: _getBarState(1, currentStep), 
              activeColor: primaryColor, 
              inactiveColor: inactiveColor
            ),
            const SizedBox(width: 8),
            // Bar 2: Sedang Disiapkan
            _TrackingBar(
              state: _getBarState(2, currentStep), 
              activeColor: primaryColor, 
              inactiveColor: inactiveColor
            ),
            const SizedBox(width: 8),
            // Bar 3: Siap Diantar
            _TrackingBar(
              state: _getBarState(3, currentStep), 
              activeColor: primaryColor, 
              inactiveColor: inactiveColor
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Label dengan logika warna
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProgressLabel("Pesanan\nDiterima", active: currentStep >= 1, align: TextAlign.left),
            _buildProgressLabel("Sedang\nDisiapkan", active: currentStep >= 2, align: TextAlign.center),
            _buildProgressLabel("Siap\nDiantar", active: currentStep >= 3, align: TextAlign.right),
          ],
        ),

        if (currentStep == 4) ...[
           const SizedBox(height: 20),
           Container(
             width: double.infinity,
             padding: const EdgeInsets.symmetric(vertical: 12),
             decoration: BoxDecoration(
               color: primaryColor.withOpacity(0.1),
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: primaryColor)
             ),
             child: Center(child: Text("Pesanan Selesai", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
           )
        ]
      ],
    );
  }

  // Fungsi menentukan status per bar
  BarState _getBarState(int barIndex, int currentStep) {
    if (currentStep == 4) return BarState.completed; // Jika completed, semua full
    if (currentStep > barIndex) return BarState.completed; // Jika sudah lewat
    if (currentStep == barIndex) return BarState.activeLoop; // JIKA INI STATUS SAAT INI -> LOOPING
    return BarState.inactive; // Belum sampai
  }

  Widget _buildProgressLabel(String text, {required bool active, required TextAlign align}) {
    return Expanded(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: (active && _startAnimation) ? 1.0 : 0.4,
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// Enum Status Bar
enum BarState { inactive, activeLoop, completed }

// --- WIDGET BAR YANG PINTAR BERANIMASI ---
class _TrackingBar extends StatefulWidget {
  final BarState state;
  final Color activeColor;
  final Color inactiveColor;

  const _TrackingBar({
    required this.state,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  State<_TrackingBar> createState() => _TrackingBarState();
}

class _TrackingBarState extends State<_TrackingBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Controller untuk animasi looping
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Jika statusnya activeLoop, jalankan animasi berulang
    if (widget.state == BarState.activeLoop) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_TrackingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cek perubahan status saat rebuild
    if (widget.state == BarState.activeLoop && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.state != BarState.activeLoop) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 8,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.inactiveColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Logika Tampilan Berdasarkan Status
            if (widget.state == BarState.completed) {
              // Jika Completed: Full Penuh (Static)
              return Container(width: double.infinity, color: widget.activeColor);
            } 
            else if (widget.state == BarState.activeLoop) {
              // Jika Active Loop: Animasi berulang dari kiri ke kanan
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FractionallySizedBox(
                    widthFactor: _controller.value, // 0.0 -> 1.0 -> 0.0
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.activeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              );
            } 
            else {
              // Jika Inactive: Kosong
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class AnimatedTranslation extends StatelessWidget {
  final Widget child;
  final bool startAnimation;

  const AnimatedTranslation({super.key, required this.child, required this.startAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      transform: Matrix4.translationValues(0, startAnimation ? 0 : 50, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: startAnimation ? 1.0 : 0.0,
        child: child,
      ),
    );
  }
}