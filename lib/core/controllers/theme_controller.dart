import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/theme_service.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  // LIGHT = cream latte vibes
  ThemeData get lightTheme {
    const cream = Color(0xFFF6EEDF);
    const darkGreen = Color(0xFF004134);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkGreen,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
      ),
      useMaterial3: false,
    );
  }

  // DARK = espresso vibes
  ThemeData get darkTheme {
    const espresso = Color(0xFF1A120B);
    const latteFoam = Color(0xFFD2B48C);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: espresso,
      colorScheme: ColorScheme.fromSeed(
        seedColor: latteFoam,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: espresso,
        foregroundColor: latteFoam,
      ),
      useMaterial3: false,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await ThemeService.getIsDark();
    isDark.value = saved;
  }

  Future<void> toggleTheme(bool value) async {
    isDark.value = value;
    await ThemeService.saveIsDark(value);
  }
}
