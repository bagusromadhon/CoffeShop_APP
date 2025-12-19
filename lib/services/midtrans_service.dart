import 'dart:convert';
import 'package:http/http.dart' as http;

class MidtransService {
  // ⚠️ GANTI STRING DI BAWAH INI DENGAN SERVER KEY ASLI ANDA
  // Pastikan diawali dengan 'SB-Mid-server-'
  static const String serverKey = 'Mid-server-D2uoOhRuzIqd0BvTOTiFE6M8'; 

  static Future<String?> getToken({
    required String orderId,
    required int grossAmount,
    required Map<String, dynamic> itemDetails, 
  }) async {
    // Pastikan URL-nya Sandbox
    const String url = 'https://app.sandbox.midtrans.com/snap/v1/transactions';

    // Encode Server Key ke Base64 (Format: "ServerKey:")
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';

    print("Mengirim Request ke Midtrans..."); // Debugging log
    print("Server Key dipakai: $serverKey"); // Debugging log

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': basicAuth, // Header Authorization sangat penting
        },
        body: jsonEncode({
          "transaction_details": {
            "order_id": orderId,
            "gross_amount": grossAmount,
          },
          "credit_card": {
            "secure": true
          }
        }),
      );

      print("Midtrans Response Code: ${response.statusCode}");
      print("Midtrans Body: ${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['redirect_url']; 
      } else {
        return null;
      }
    } catch (e) {
      print("Exception Midtrans: $e");
      return null;
    }
  }
}