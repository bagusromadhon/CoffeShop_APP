import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localParams = FlutterLocalNotificationsPlugin();

  // 1. Inisialisasi Service (Panggil di main.dart)
  static Future<void> initialize() async {
    // Minta Izin Notifikasi
    await FirebaseMessaging.instance.requestPermission();

    // Setup Local Notification (Android)
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    await _localParams.initialize(initSettings);

    // --- PENTING: BUAT CHANNEL SUARA KHUSUS (Android 8.0+) ---
    // Channel 1: Processing
    await _createChannel(
      'channel_processing',
      'Pesanan Disiapkan',
      'Notifikasi saat pesanan sedang dibuat',
      'sound_processing', // Nama file di folder raw tanpa ekstensi
    );

    // Channel 2: Ready
    await _createChannel(
      'channel_ready',
      'Pesanan Siap',
      'Notifikasi saat pesanan siap diambil',
      'pesanan_di_antar',
    );

    // Channel 3: Completed
    await _createChannel(
      'channel_completed',
      'Pesanan Selesai',
      'Notifikasi saat pesanan selesai',
      'unik',
    );

    // Upload Token ke Supabase agar Staff bisa kirim ke user ini
    await _saveTokenToSupabase();
  }

  static Future<void> _createChannel(String id, String name, String desc, String soundFile) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      id,
      name,
      description: desc,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundFile), // File di folder raw
    );

    await _localParams
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _saveTokenToSupabase() async {
    final token = await FirebaseMessaging.instance.getToken();
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user != null && token != null) {
      // Pastikan tabel 'profiles' atau 'users' punya kolom 'fcm_token'
      await Supabase.instance.client
          .from('users') // Ganti dengan nama tabel user kamu
          .update({'fcm_token': token})
          .eq('id', user.id);
    }
  }
}