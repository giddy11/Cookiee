import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../services/api_service.dart';
import 'profile2_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService());
    Get.put<HomeController>(HomeController());
    Profile2Binding().dependencies();
  }
}
