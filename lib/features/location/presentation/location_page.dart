import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../controllers/location_controller.dart';

class LocationPage extends StatelessWidget { // Gunakan StatelessWidget + Get.put agar lebih stabil
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller (Agar aman jika belum ada di binding)
    final controller = Get.put(LocationController()); 
    final MapController mapController = MapController();

    // Lokasi Target (Keko Coffee - Misal di Malang)
    final LatLng kekoLocation = const LatLng(-7.921346, 112.598223); 

    return Scaffold(
      body: Stack(
        children: [
          // ===========================================
          // LAYER 1: PETA (OpenStreetMap)
          // ===========================================
          Obx(() {
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.currentPosition.value.latitude != 0
                    ? controller.currentPosition.value
                    : const LatLng(-7.943382, 112.614479), // Default Malang
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.bagus.coffeeshop', // Sesuaikan nama paket
                ),
                MarkerLayer(
                  markers: [
                    // MARKER 1: KEKO COFFEE (Target)
                    Marker(
                      point: kekoLocation,
                      width: 80,
                      height: 80,
                      child: const Column(
                        children: [
                          Icon(Icons.local_cafe, color: Colors.orange, size: 40),
                          Text("Keko Coffee", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                        ],
                      ),
                    ),
                    
                    // MARKER 2: POSISI USER (Rumah/Biru)
                    if (controller.currentPosition.value.latitude != 0)
                      Marker(
                        point: controller.currentPosition.value,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.home_filled, 
                          color: Colors.blue, 
                          size: 40
                        ),
                      ),
                  ],
                ),
                // Opsional: Garis Polyline antara User dan Toko
                 if (controller.currentPosition.value.latitude != 0)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [controller.currentPosition.value, kekoLocation],
                        strokeWidth: 4.0,
                        color: Colors.blue.withOpacity(0.5),
                        pattern: const StrokePattern.dotted(), // Garis putus-putus
                      ),
                    ],
                  ),
              ],
            );
          }),

          // ===========================================
          // LAYER 2: PANEL EKSPERIMEN (DATA RAW)
          // ===========================================
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Data Eksperimen Modul 5", 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Obx(() => Table(
                    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                    children: [
                      _buildRow("Lat/Long", "${controller.latitude.value}, ${controller.longitude.value}"),
                      _buildRow("Akurasi", "${controller.accuracy.value} m"),
                      _buildRow("Speed", "${controller.speed.value} m/s"),
                    ],
                  )),
                  const SizedBox(height: 10),
                  
                  // Tombol Kontrol
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Obx(() => FilterChip(
                          label: Text(controller.isGpsMode.value ? "Mode: GPS" : "Mode: Network"),
                          selected: controller.isGpsMode.value,
                          onSelected: (val) => controller.toggleMode(val),
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green[100],
                        )),
                        const SizedBox(width: 8),
                        Obx(() => ActionChip(
                          avatar: Icon(controller.isLiveTracking.value ? Icons.stop : Icons.play_arrow, size: 16),
                          label: Text(controller.isLiveTracking.value ? "Stop Live" : "Start Live"),
                          onPressed: () => controller.toggleLiveTracking(),
                          backgroundColor: controller.isLiveTracking.value ? Colors.red[100] : Colors.blue[100],
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.my_location, size: 16),
                      label: const Text("Ambil Lokasi & Pusatkan"),
                      onPressed: () async {
                        await controller.getCurrentLocation();
                        if(controller.currentPosition.value.latitude != 0){
                           mapController.move(controller.currentPosition.value, 15);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004134), 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 0) // Kompak
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ===========================================
          // LAYER 3: KARTU DETAIL LOKASI
          // ===========================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Keko Coffee & eatery", 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(" (220) • Coffee Shop", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      // TOMBOL ARAH (Fixed)
                      InkWell(
                        onTap: () {
                          _launchMapsUrl(kekoLocation.latitude, kekoLocation.longitude);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.directions, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Jl. Danau Bratan, Malang", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk baris tabel
  TableRow _buildRow(String label, String value) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))),
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
    ]);
  }

  // Helper Buka Google Maps
  Future<void> _launchMapsUrl(double lat, double lon) async {
    final Uri url = Uri.parse("http://maps.google.com/maps?q=$lat,$lon");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Tidak bisa membuka aplikasi peta");
    }
  }
}