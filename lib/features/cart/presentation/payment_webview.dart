import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebview extends StatefulWidget {
  final String url;
  final Function() onSuccess;

  const PaymentWebview({super.key, required this.url, required this.onSuccess});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  late final WebViewController _controller;
  bool _isSuccessTriggered = false; // Mencegah pemanggilan ganda

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
             print("Page Started: $url"); // Debugging
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            print("URL Changed: $url"); // Debugging
            _checkTransactionStatus(url);
          },
          onPageFinished: (String url) {
             print("Page Finished: $url"); // Debugging
             _checkTransactionStatus(url);
          },
          onWebResourceError: (error) {
            print("Web Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _checkTransactionStatus(String url) {
    if (_isSuccessTriggered) return;

    if (url.contains('transaction_status=settlement') || 
        url.contains('transaction_status=capture') ||
        url.contains('status_code=200') ||
        url.contains('success') ||
        url.contains('gopay/partner/finish')) { 
      
      print("✅ DETEKSI SUKSES DARI URL!");
      _triggerSuccess();
    }
  }

  void _triggerSuccess() {
    if (_isSuccessTriggered) return;
    _isSuccessTriggered = true;
    widget.onSuccess(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: const Color(0xFF004134),
        foregroundColor: Colors.white,
        actions: [
          // --- TOMBOL DARURAT UNTUK DEMO ---
          TextButton.icon(
            onPressed: () {
              print("👆 Tombol Manual Ditekan");
              _triggerSuccess();
            },
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text("Selesai", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}