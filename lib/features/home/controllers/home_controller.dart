import 'package:get/get.dart';

class HomeController extends GetxController {
  // contoh state kecil biar kelihatan GetX jalan
  var username = 'Guest'.obs;

  // nanti bisa diisi dari Supabase profiles
  void setUsername(String name) {
    username.value = name;
  }
}
