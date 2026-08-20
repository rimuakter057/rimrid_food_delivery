import 'package:flutter/foundation.dart';
import '../../../data/datasources/remote/driver_remote_data_source.dart';
import '../../../data/mock/mock_orders.dart';
import '../../../data/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final DriverRemoteDataSource _driverRemoteDataSource;
  final List<OrderModel> _orders = List.from(MockOrders.orders);

  OrderProvider({DriverRemoteDataSource? driverRemoteDataSource})
      : _driverRemoteDataSource = driverRemoteDataSource ?? DriverRemoteDataSource();

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

  Future<OrderModel> createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double discount,
    required double total,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    final restaurantName = items.isNotEmpty ? items.first.food.restaurantName : 'RimRid Restaurant';
    final restaurantLogo = items.isNotEmpty ? items.first.food.imageUrl : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200';

    // Real random driver identity (name/phone/photo) via randomuser.me.
    String driverName = 'Michael Scott';
    String driverPhone = '+1 (555) 234-5678';
    String driverAvatar = 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=200';
    try {
      final driver = await _driverRemoteDataSource.fetchDriver();
      if (driver != null) {
        final name = driver['name'] as Map<String, dynamic>?;
        final picture = driver['picture'] as Map<String, dynamic>?;
        driverName = [name?['first'], name?['last']].where((s) => s != null).join(' ').trim();
        if (driverName.isEmpty) driverName = 'Michael Scott';
        driverPhone = (driver['phone'] ?? driverPhone).toString();
        driverAvatar = (picture?['large'] ?? driverAvatar).toString();
      }
    } catch (_) {
      // Keep the fallback driver identity if the API call fails.
    }

    final newOrder = OrderModel(
      id: 'ORD-${(10000 + DateTime.now().millisecond % 89999)}',
      restaurantName: restaurantName,
      restaurantLogo: restaurantLogo,
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
      driverName: driverName,
      driverPhone: driverPhone,
      driverAvatar: driverAvatar,
      estimatedTime: '20-30 min',
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }
}
