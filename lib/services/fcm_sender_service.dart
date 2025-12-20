import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmSenderService {
  // Project ID diambil dari screenshot Anda (keko-587c3)
  // Pastikan ini sesuai dengan yang ada di Firebase Console -> Project Settings
  static const String _projectId = 'keko-587c3'; 

  // --- FUNGSI BARU: MENDAPATKAN TOKEN DARI FILE JSON ---
  static Future<String> _getAccessToken() async {
    try {
      // Membaca file json yang sudah Anda taruh di folder assets
      final String jsonString = await rootBundle.loadString('assets/service_account.json');
      final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonString);

      // Meminta izin scope untuk Cloud Messaging
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(serviceAccountCredentials, scopes);
      
      // Mengembalikan Access Token (berlaku 1 jam)
      return client.credentials.accessToken.data;
    } catch (e) {
      print("Error mengambil Access Token: $e");
      print("Pastikan file 'assets/service_account.json' ada dan terdaftar di pubspec.yaml");
      return '';
    }
  }

  static Future<void> sendStatusNotification({
    required String userToken,
    required String status,
  }) async {
    // 1. Dapatkan Token Keamanan
    final String accessToken = await _getAccessToken();
    if (accessToken.isEmpty) return;

    String title = "Status Pesanan";
    String body = "";
    String channelId = "";

    // 2. Logika Pesan & Suara (Sama seperti sebelumnya)
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        title = "Pesanan Sedang Disiapkan 👨‍🍳";
        body = "Barista kami sedang meracik pesananmu.";
        channelId = "channel_processing"; 
        break;
      case 'READY':
        title = "Pesanan Siap! ☕";
        body = "Silakan ambil pesananmu di meja pengambilan.";
        channelId = "channel_ready";
        break;
      case 'COMPLETED':
        title = "Terima Kasih 🙏";
        body = "Pesanan selesai. Selamat menikmati!";
        channelId = "channel_completed";
        break;
      default:
        return; 
    }

    // 3. URL Endpoint BARU (HTTP v1)
    final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Pakai Bearer Token dari JSON
        },
        body: jsonEncode(
          {
            "message": {
              "token": userToken,
              "notification": {
                "title": title,
                "body": body,
              },
              // Konfigurasi Khusus Android agar Suara Keluar
              "android": {
                "notification": {
                  "channel_id": channelId, // KUNCI UTAMA SUARA
                  "click_action": "FLUTTER_NOTIFICATION_CLICK"
                }
              },
              "data": {
                "status": status,
              }
            }
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Notifikasi Sukses dikirim ke channel: $channelId");
      } else {
        print("Gagal Kirim Notif: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error Network FCM: $e");
    }
  }
}