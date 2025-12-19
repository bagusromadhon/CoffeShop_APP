import 'package:coffe_shop_app/features/dashboard/binding/dashboard_binding.dart';
import 'package:coffe_shop_app/features/staff/presentation/staff_dashboard_page.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/bindings/auth_binding.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/home/bindings/home_binding.dart';

import '../../features/auth/presentation/auth_gate_page.dart';

// import '../../core/controllers/theme_controller.dart';
import '../../features/settings/settings_page.dart';
import '../../features/cart/presentation/cart_page.dart';

import '../../features/location/presentation/location_page.dart';
import '../../features/location/controllers/location_controller.dart';

import '../../features/dashboard/presentation/dashboard_page.dart';
import 'app_routes.dart';

class AppPages {
  // static const initial = Routes.login;
  static const initial = Routes.authGate;  


  static final pages = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.authGate,
      page: () => const AuthGatePage(),
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
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
  name: Routes.staffDashboard,
  page: () => const StaffDashboardPage(),
),
GetPage(
  name: Routes.LOCATION, 
  page: () => const LocationPage(),
  binding: BindingsBuilder(() {
    Get.put(LocationController());
  }),
),
    GetPage(
  name: Routes.cart,
  page: () => const CartPage(),
),

  ];
}
