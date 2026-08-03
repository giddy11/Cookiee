import 'package:get/get.dart';

import '../models/order_summary_model.dart';
import '../routes/app_routes.dart';

class SuccessController extends GetxController {
  final OrderSummary orderSummary = Get.arguments as OrderSummary;

  void backToHome() => Get.offAllNamed(Routes.home);
}
