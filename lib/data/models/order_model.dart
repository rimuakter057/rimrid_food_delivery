import 'package:equatable/equatable.dart';
import 'food_model.dart';

enum OrderStatus {
  confirmed,
  preparing,
  onTheWay,
  delivered,
  cancelled,
}

class CartItemModel extends Equatable {
  final String id;
  final FoodModel food;
  final int quantity;
  final List<AddOnModel> selectedAddOns;
  final String specialInstructions;

  const CartItemModel({
    required this.id,
    required this.food,
    this.quantity = 1,
    this.selectedAddOns = const [],
    this.specialInstructions = '',
  });

  double get addOnsPrice {
    return selectedAddOns.fold(0.0, (sum, item) => sum + item.price);
  }

  double get unitPrice => food.price + addOnsPrice;

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    FoodModel? food,
    int? quantity,
    List<AddOnModel>? selectedAddOns,
    String? specialInstructions,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [id, food, quantity, selectedAddOns, specialInstructions];
}

class OrderModel extends Equatable {
  final String id;
  final String restaurantName;
  final String restaurantLogo;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double totalPrice;
  final DateTime createdAt;
  final OrderStatus status;
  final String deliveryAddress;
  final String paymentMethod;
  final String? driverName;
  final String? driverPhone;
  final String? driverAvatar;
  final String estimatedTime;

  const OrderModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.driverName,
    this.driverPhone,
    this.driverAvatar,
    required this.estimatedTime,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantName,
        restaurantLogo,
        items,
        subtotal,
        deliveryFee,
        tax,
        discount,
        totalPrice,
        createdAt,
        status,
        deliveryAddress,
        paymentMethod,
        driverName,
        driverPhone,
        driverAvatar,
        estimatedTime,
      ];
}
