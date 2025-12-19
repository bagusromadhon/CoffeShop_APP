import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class PaymentWebview extends StatefulWidget {
  final String url;
  final Function() onSuccess;

  const PaymentWebview({super.key, required this.url, required this.onSuccess});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Logika sederhana: Jika URL mengandung kata 'finish' atau 'success'
            // Anggap pembayaran berhasil (Untuk Demo)
            if (url.contains('status_code=200') || url.contains('transaction_status=settlement')) {
               widget.onSuccess();
               Get.back(); // Tutup WebView
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: const Color(0xFF004134),
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}