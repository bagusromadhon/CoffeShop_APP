import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/theme_controller.dart';

class SettingsPage extends GetView<ThemeController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Obx(
        () => ListView(
          children: [
            SwitchListTile(
              title: const Text('Espresso mode (Dark Theme)'),
              subtitle: const Text('Kalau mati: Cream Latte (Light Theme)'),
              value: controller.isDark.value,
              onChanged: (val) {
                controller.toggleTheme(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
