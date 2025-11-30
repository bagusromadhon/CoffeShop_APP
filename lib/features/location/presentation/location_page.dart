import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/location_controller.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller peta untuk fitur 'Center'
    final MapController mapController = MapController();

    // Lokasi Target (Keko Coffee - Misal di Malang)
    // Anda bisa ganti koordinat ini sesuai lokasi Keko sebenarnya
    final LatLng kekoLocation = LatLng(-7.921346, 112.598223); 

    return Scaffold(
      body: Stack(
        children: [
          // ===========================================
          // LAYER 1: PETA (OpenStreetMap)
          // ===========================================
          Obx(() {
            // Agar peta otomatis pindah saat marker user bergerak
            // (Opsional: matikan ini jika ingin peta statis saat digeser manual)
            if (controller.currentPosition.value.latitude != 0) {
               // mapController.move(controller.currentPosition.value, 15);
            }
            
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                // Default start di Malang atau posisi user jika sudah ada
                initialCenter: controller.currentPosition.value.latitude != 0
                    ? controller.currentPosition.value
                    : const LatLng(-7.943382, 112.614479), // Default Malang
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.keko_app',
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
                    // Hanya muncul jika lokasi sudah didapat (lat != 0)
                    if (controller.currentPosition.value.latitude != 0)
                      Marker(
                        point: controller.currentPosition.value,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.home_filled, // Icon Rumah sesuai desain
                          color: Colors.blue, 
                          size: 40
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),

          // ===========================================
          // LAYER 2: PANEL EKSPERIMEN (WAJIB UTK MODUL)
          // Letak: Atas
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
                  // Data Statistik untuk Laporan
                  const Text("Data Eksperimen Modul 5", 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Obx(() => Table(
                    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                    children: [
                      _buildRow("Lat/Long", "${controller.latitude.value}, ${controller.longitude.value}"),
                      _buildRow("Akurasi", "${controller.accuracy.value} m (Makin kecil makin bagus)"),
                      _buildRow("Speed", "${controller.speed.value} m/s"),
                    ],
                  )),
                  const SizedBox(height: 10),
                  
                  // Tombol Kontrol Eksperimen
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Toggle GPS/Network
                        Obx(() => FilterChip(
                          label: Text(controller.isGpsMode.value ? "Mode: GPS (High)" : "Mode: Network (Low)"),
                          selected: controller.isGpsMode.value,
                          onSelected: (val) => controller.toggleMode(val),
                          checkmarkColor: Colors.white,
                          selectedColor: Colors.green[200],
                        )),
                        const SizedBox(width: 8),
                        // Tombol Live Tracking
                        Obx(() => ActionChip(
                          avatar: Icon(controller.isLiveTracking.value ? Icons.stop : Icons.play_arrow),
                          label: Text(controller.isLiveTracking.value ? "Stop Live" : "Start Live"),
                          onPressed: () => controller.toggleLiveTracking(),
                          backgroundColor: controller.isLiveTracking.value ? Colors.red[100] : Colors.blue[100],
                        )),
                      ],
                    ),
                  ),
                  // Tombol Refresh Manual (One-Time)
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text("Ambil Lokasi Saat Ini (Sekali)"),
                      onPressed: () {
                        controller.getCurrentLocation();
                        // Opsional: Pindahkan kamera ke user
                        if(controller.currentPosition.value.latitude != 0){
                           mapController.move(controller.currentPosition.value, 16);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004134), foregroundColor: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ===========================================
          // LAYER 3: KARTU DETAIL LOKASI (SESUAI DESAIN FIGMA)
          // Letak: Bawah
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
                  // Judul & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Keko Coffee & eatery", 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text("4.2", style: TextStyle(fontWeight: FontWeight.bold)),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(" (220) • Convenience store", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      // Tombol Arah (Direction)
                      InkWell(
                        onTap: () {
                          // TODO: Buka Google Maps Eksternal
                          // _launchMapsUrl(kekoLocation.latitude, kekoLocation.longitude);
                          Get.snackbar("Info", "Membuka Google Maps...");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
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
                  const Text("Jl. Bukit Pala 2, No 19 (Sesuai desain)", 
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Text("Closed", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      Text(" • Opens 8 am", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20), // Spacer untuk bottom nav bar jika ada
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
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(label, style: const TextStyle(color: Colors.grey))),
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
    ]);
  }
}