import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/recipe_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  bool get isEmpty => items.isEmpty;

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity.value);

  double get total => items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addItem(Recipe recipe, int quantity) {
    final existingIndex = items.indexWhere((item) => item.recipe.id == recipe.id);
    if (existingIndex != -1) {
      items[existingIndex].quantity.value += quantity;
    } else {
      items.add(CartItem(recipe: recipe, quantity: quantity));
    }
    items.refresh();
  }

  void incrementQuantity(CartItem item) => item.quantity.value++;

  void decrementQuantity(CartItem item) {
    if (item.quantity.value > 1) item.quantity.value--;
  }

  void removeItem(CartItem item) => items.remove(item);

  void clearCart() => items.clear();
}
