import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/home_page.dart'; // dummy home

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

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      home: session == null ? const LoginPage() : const HomePage(),
    );
  }
}
