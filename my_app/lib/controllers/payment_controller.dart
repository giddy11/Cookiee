import 'dart:math';

import 'package:get/get.dart';

import '../models/delivery_details_model.dart';
import '../models/order_summary_model.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';

class PaymentController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final DeliveryDetails deliveryDetails = Get.arguments as DeliveryDetails;

  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;

  double get total => _cartController.total;

  Future<void> payNow() async {
    isProcessing.value = true;
    errorMessage.value = '';

    await Future.delayed(const Duration(seconds: 2));

    // Mock gateway: randomly simulate a failure so the error/retry path is
    // actually reachable, since there's no real payment backend to fail.
    final succeeded = Random().nextDouble() > 0.2;

    if (!succeeded) {
      errorMessage.value = 'Payment could not be processed. Please try again.';
      isProcessing.value = false;
      return;
    }

    final orderSummary = OrderSummary(
      orderId: _generateOrderId(),
      items: List.of(_cartController.items),
      total: _cartController.total,
      placedAt: DateTime.now(),
      deliveryName: deliveryDetails.name,
      deliveryAddress: deliveryDetails.address,
    );

    _cartController.clearCart();
    isProcessing.value = false;

    Get.offAllNamed(Routes.success, arguments: orderSummary);
  }

  String _generateOrderId() {
    final random = Random();
    final suffix = List.generate(6, (_) => random.nextInt(10)).join();
    return 'CK-$suffix';
  }
}
