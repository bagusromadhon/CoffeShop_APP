import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_pages.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'core/controllers/theme_controller.dart';
import 'features/cart/controllers/cart_controller.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Hive.initFlutter();
  await Hive.openBox('cart');

  // register ThemeController sebagai global
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
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
        theme: themeC.lightTheme,
        darkTheme: themeC.darkTheme,
        themeMode: themeC.isDark.value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}

