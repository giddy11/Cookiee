import 'cart_item_model.dart';

class OrderSummary {
  final String orderId;
  final List<CartItem> items;
  final double total;
  final DateTime placedAt;
  final String deliveryName;
  final String deliveryAddress;

  const OrderSummary({
    required this.orderId,
    required this.items,
    required this.total,
    required this.placedAt,
    required this.deliveryName,
    required this.deliveryAddress,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity.value);
}
