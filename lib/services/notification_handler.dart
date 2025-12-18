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
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Izin user: ${settings.authorizationStatus}');

    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token'); 
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Aplikasi dibuka dari Terminated");
        Future.delayed(const Duration(seconds: 1), () {
           Get.toNamed(Routes.cart); 
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Aplikasi dibuka dari Background");
      Get.toNamed(Routes.cart);
    });
  }

  Future<void> initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        Get.toNamed(Routes.cart);
      },
    );

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id_1',        
              'Keko Coffee Promo',   
              channelDescription: 'Info promo menarik keko',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
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