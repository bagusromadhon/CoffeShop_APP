import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _keyIsDark = 'isDarkTheme';

  static Future<bool> getIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    // default: false (cream latte)
    return prefs.getBool(_keyIsDark) ?? false;
  }

  static Future<void> saveIsDark(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, value);
  }
}
