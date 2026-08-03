import 'package:get/get.dart';

import '../models/recipe_model.dart';
import 'cart_controller.dart';

class RecipeDetailController extends GetxController {
  final Recipe recipe;
  RecipeDetailController(this.recipe);

  final CartController _cartController = Get.find<CartController>();

  final RxInt quantity = 1.obs;

  void increment() => quantity.value++;

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    _cartController.addItem(recipe, quantity.value);
    Get.snackbar(
      'Added to cart',
      '${quantity.value} x ${recipe.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
    quantity.value = 1;
  }
}
