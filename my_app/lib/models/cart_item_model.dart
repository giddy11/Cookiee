import 'package:get/get.dart';

import 'recipe_model.dart';

class CartItem {
  final Recipe recipe;
  final RxInt quantity;

  CartItem({required this.recipe, int quantity = 1}) : quantity = quantity.obs;

  double get subtotal => recipe.price * quantity.value;
}
