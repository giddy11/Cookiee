import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';

const _brandColor = Color(0xFF00BCD4);

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: _brandColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  size: 44,
                  color: _brandColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Amount to Pay',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${controller.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Delivering to ${controller.deliveryDetails.name}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              ),
              const Spacer(),
              Obx(() {
                if (controller.isProcessing.value) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(color: _brandColor),
                      SizedBox(height: 16),
                      Text(
                        'Processing payment…',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: Color(0xFFE05252),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.payNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brandColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.payNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
