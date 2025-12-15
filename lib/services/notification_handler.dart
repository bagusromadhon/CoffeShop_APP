import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../core/routes/app_routes.dart';

// 1. HANDLER BACKGROUND (Wajib diletakkan di luar class / Top Level) [cite: 426]
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Pesan diterima di background: ${message.notification?.title}');
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();

  // 2. FUNGSI UTAMA: Inisialisasi Firebase Messaging [cite: 426]
  Future<void> initPushNotification() async {
    // Minta izin notifikasi ke user (Wajib untuk Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Izin user: ${settings.authorizationStatus}');

    // Ambil Token FCM (Ini yang nanti dicopy ke Firebase Console) [cite: 426]
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token'); 
    });

    // Pasang handler background [cite: 439]
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handler 1: Saat aplikasi mati total (Terminated) lalu notifikasi diklik [cite: 435]
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Aplikasi dibuka dari Terminated");
        // Beri jeda sedikit agar GetX siap, lalu pindah ke Cart
        Future.delayed(const Duration(seconds: 1), () {
           Get.toNamed(Routes.cart); 
        });
      }
    });

    // Handler 2: Saat aplikasi di-minimize (Background) lalu notifikasi diklik [cite: 529]
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Aplikasi dibuka dari Background");
      Get.toNamed(Routes.cart);
    });
  }

  // 3. FUNGSI LOKAL: Untuk menampilkan notifikasi saat aplikasi dibuka (Foreground) [cite: 534]
  Future<void> initLocalNotification() async {
    // Setup Icon Android (Pastikan gambar 'ic_launcher' ada di folder mipmap)
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        // Navigasi saat banner notifikasi lokal diklik
        Get.toNamed(Routes.cart);
      },
    );

    // Listener Pesan Masuk (Foreground) [cite: 510]
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        // Tampilkan Banner Notifikasi
        _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id_1',        // ID Channel
              'Keko Coffee Promo',   // Nama Channel
              channelDescription: 'Info promo menarik keko',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              // CUSTOM SOUND: Panggil file 'unik.mp3' di folder raw
              sound: const RawResourceAndroidNotificationSound('unik'), 
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }
}