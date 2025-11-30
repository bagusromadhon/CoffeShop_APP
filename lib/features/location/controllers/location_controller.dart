import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  // 1. VARIABEL DATA (Observable untuk UI)
  var currentPosition = LatLng(0, 0).obs; // Koordinat saat ini
  var latitude = '0.0'.obs;
  var longitude = '0.0'.obs;
  var accuracy = '0.0'.obs; // Penting untuk laporan eksperimen
  var altitude = '0.0'.obs;
  var speed = '0.0'.obs;    // Penting untuk eksperimen bergerak

  // 2. STATUS & MODE
  var isLoading = false.obs;
  var isGpsMode = true.obs; // Toggle: True = GPS (High), False = Network (Low/Balanced)
  var isLiveTracking = false.obs;
  
  // Stream subscription untuk live tracking
  StreamSubscription<Position>? _positionStream;

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }

  // ==========================================
  // FUNGSI UTAMA: Mendapatkan Lokasi Sekali (One-Time)
  // Cocok untuk Eksperimen 1 & 2 (Statis)
  // ==========================================
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      
      // 1. Cek Izin dulu
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'GPS/Lokasi belum aktif. Silakan nyalakan.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Izin lokasi ditolak.');
          return;
        }
      }

      // 2. Tentukan Akurasi berdasarkan Mode (Eksperimen GPS vs Network)
      // GPS Mode = High / Best (Pakai Satelit)
      // Network Mode = Low / Balanced (Pakai WiFi/Tower, lebih hemat baterai tapi kurang akurat)
      LocationSettings locationSettings = LocationSettings(
        accuracy: isGpsMode.value ? LocationAccuracy.high : LocationAccuracy.low,
        distanceFilter: 10, // Update tiap geser 10 meter (opsional)
      );

      // 3. Ambil Posisi
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings
      );

      // 4. Update UI
      _updateLocationData(position);
      
      Get.snackbar(
        'Sukses', 
        'Lokasi didapat via ${isGpsMode.value ? "GPS" : "Network"}',
        snackPosition: SnackPosition.BOTTOM
      );

    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil lokasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // FUNGSI LIVE TRACKING (Real-Time)
  // Cocok untuk Eksperimen 3 (Bergerak)
  // ==========================================
  void toggleLiveTracking() {
    if (isLiveTracking.value) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() {
    isLiveTracking.value = true;
    
    // Settingan stream
    final locationSettings = LocationSettings(
      accuracy: isGpsMode.value ? LocationAccuracy.high : LocationAccuracy.low,
      distanceFilter: 5, // Update setiap bergerak 5 meter
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          _updateLocationData(position);
          print("STREAM UPDATE: ${position.latitude}, ${position.longitude}");
        });
        
    Get.snackbar('Tracking', 'Live tracking dimulai...');
  }

  void _stopTracking() {
    isLiveTracking.value = false;
    _positionStream?.cancel();
    Get.snackbar('Tracking', 'Live tracking berhenti.');
  }

  // Helper untuk update variabel
  void _updateLocationData(Position position) {
    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    accuracy.value = position.accuracy.toStringAsFixed(1); // dalam meter
    altitude.value = position.altitude.toStringAsFixed(1);
    speed.value = position.speed.toStringAsFixed(2); // m/s
    
    // Update koordinat peta
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }
  
  // Helper untuk ganti mode (GPS vs Network)
  void toggleMode(bool value) {
    isGpsMode.value = value;
    // Jika sedang tracking, restart tracking dengan mode baru
    if (isLiveTracking.value) {
      _stopTracking();
      _startTracking();
    }
  }
}