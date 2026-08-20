import '../models/order_model.dart';

/// Order history now comes purely from orders actually placed through
/// checkout (see OrderProvider.createOrder), same as a real app — no seeded
/// historical orders here.
class MockOrders {
  static const List<OrderModel> orders = [];
}
