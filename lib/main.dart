import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load .env
  await dotenv.load(fileName: ".env");

  // init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KEKO Coffee',
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      // sementara theme simple dulu aja
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
