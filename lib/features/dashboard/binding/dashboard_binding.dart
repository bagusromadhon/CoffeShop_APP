import 'package:coffe_shop_app/core/controllers/theme_controller.dart';
import 'package:coffe_shop_app/features/location/controllers/location_controller.dart';
import 'package:coffe_shop_app/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart'; 

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController()); 
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}