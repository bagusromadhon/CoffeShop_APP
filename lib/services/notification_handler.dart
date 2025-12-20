import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../core/routes/app_routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Pesan diterima di background: ${message.notification?.title}');
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotification() async {
    // 1. Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Izin user: ${settings.authorizationStatus}');

    // 2. Cek Token (Opsional, untuk debug)
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token'); 
    });

    // 3. Setup Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle saat aplikasi dibuka dari posisi Terminated (Mati total)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Aplikasi dibuka dari Terminated");
        Future.delayed(const Duration(seconds: 1), () {
           Get.toNamed(Routes.cart); 
        });
      }
    });

    // Handle saat aplikasi dibuka dari Background (Minimised)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Aplikasi dibuka dari Background");
      Get.toNamed(Routes.cart);
    });
  }

  Future<void> initLocalNotification() async {
    // Setup Icon
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        Get.toNamed(Routes.cart);
      },
    );

    // ============================================================
    // BAGIAN PENTING: MENDAFTARKAN 3 CHANNEL SUARA UNIK
    // ============================================================
    
    // 1. Channel Processing (sound_processing.mp3)
    await _createChannel(
      'channel_processing', 
      'Status Processing', 
      'Notifikasi saat pesanan sedang diproses',
      'sound_processing' 
    );

    // 2. Channel Ready (pesanan_di_antar.mp3)
    await _createChannel(
      'channel_ready', 
      'Status Ready', 
      'Notifikasi saat pesanan siap',
      'pesanan_di_antar' 
    );

    // 3. Channel Completed (unik.mp3)
    await _createChannel(
      'channel_completed', 
      'Status Selesai', 
      'Notifikasi saat pesanan selesai',
      'unik' 
    );

    // ============================================================

    // Listener untuk Notifikasi FCM saat aplikasi dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        // Cek channel ID dari payload FCM, kalau tidak ada pakai default
        String channelId = android.channelId ?? 'channel_id_1';
        
        _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelId, // Gunakan ID dinamis dari FCM atau Default
              'General Notifications',   
              channelDescription: 'Pemberitahuan umum',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              // Default sound jika channel tidak spesifik
              sound: const RawResourceAndroidNotificationSound('unik'), 
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  // --- Helper Function untuk membuat Channel ---
  Future<void> _createChannel(String id, String name, String desc, String soundName) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      id,
      name,
      description: desc,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundName), // KUNCI SUARA
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}