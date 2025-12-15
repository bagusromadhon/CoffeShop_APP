import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  
  var currentPosition = LatLng(0, 0).obs; 
  var latitude = '0.0'.obs;
  var longitude = '0.0'.obs;
  var accuracy = '0.0'.obs; 
  var altitude = '0.0'.obs;
  var speed = '0.0'.obs;    

  
  var isLoading = false.obs;
  var isGpsMode = true.obs; 
  var isLiveTracking = false.obs;
  
  
  StreamSubscription<Position>? _positionStream;

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }

  
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      
      
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

      
      LocationSettings locationSettings = LocationSettings(
        accuracy: isGpsMode.value ? LocationAccuracy.high : LocationAccuracy.low,
        distanceFilter: 10, 
      );

      
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings
      );

      
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

  
  void toggleLiveTracking() {
    if (isLiveTracking.value) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() {
    isLiveTracking.value = true;
    
    
    final locationSettings = LocationSettings(
      accuracy: isGpsMode.value ? LocationAccuracy.high : LocationAccuracy.low,
      distanceFilter: 5, 
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

  
  void _updateLocationData(Position position) {
    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    accuracy.value = position.accuracy.toStringAsFixed(1); 
    altitude.value = position.altitude.toStringAsFixed(1);
    speed.value = position.speed.toStringAsFixed(2); 
    
    
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }
  
  
  void toggleMode(bool value) {
    isGpsMode.value = value;
    
    if (isLiveTracking.value) {
      _stopTracking();
      _startTracking();
    }
  }
}