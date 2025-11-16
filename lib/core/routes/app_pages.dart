import 'package:get/get.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/bindings/auth_binding.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/home/bindings/home_binding.dart';

import '../../core/controllers/theme_controller.dart';
import '../../features/settings/settings_page.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final pages = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      // kita gak perlu binding khusus di settings
    ),
  ];
}
