import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_orders.dart';
import '../../../data/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = List.from(MockOrders.orders);

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders => _orders.where((o) =>
      o.status == OrderStatus.confirmed ||
      o.status == OrderStatus.preparing ||
      o.status == OrderStatus.onTheWay).toList();

  List<OrderModel> get pastOrders => _orders.where((o) =>
      o.status == OrderStatus.delivered ||
      o.status == OrderStatus.cancelled).toList();

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  OrderModel createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double discount,
    required double total,
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final restaurantName = items.isNotEmpty ? items.first.food.restaurantName : 'RimRid Restaurant';
    final newOrder = OrderModel(
      id: 'ORD-${(10000 + DateTime.now().millisecond % 89999)}',
      restaurantName: restaurantName,
      restaurantLogo: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200',
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      discount: discount,
      totalPrice: total,
      createdAt: DateTime.now(),
      status: OrderStatus.confirmed,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      driverName: 'Michael Scott',
      driverPhone: '+1 (555) 234-5678',
      driverAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=200',
      estimatedTime: '20-30 min',
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }
}
