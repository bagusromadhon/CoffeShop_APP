import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/controllers/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'features/cart/controllers/cart_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env
  await dotenv.load(fileName: ".env");

  // init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // init Hive + buka box cart
  await Hive.initFlutter();
  await Hive.openBox('cart');

  // register global controllers
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KEKO Coffee',
        initialRoute: AppPages.initial, // pastikan ini = Routes.authGate
        getPages: AppPages.pages,
        theme: themeC.lightTheme,
        darkTheme: themeC.darkTheme,
        themeMode:
            themeC.isDark.value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
