import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/order_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String? _appliedPromoCode;
  double _discountAmount = 0.0;

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedPromoCode => _appliedPromoCode;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0.0;
    return AppConstants.defaultDeliveryFee;
  }

  double get tax => subtotal * AppConstants.defaultTaxRate;

  double get discount => _discountAmount;

  double get total {
    if (_items.isEmpty) return 0.0;
    final calcTotal = subtotal + deliveryFee + tax - discount;
    return calcTotal < 0 ? 0.0 : calcTotal;
  }

  void addToCart(FoodModel food, {int quantity = 1, List<AddOnModel> selectedAddOns = const [], String specialInstructions = ''}) {
    // Check if identical food with exact same add-ons already exists
    final existingIndex = _items.indexWhere((item) {
      if (item.food.id != food.id) return false;
      if (item.selectedAddOns.length != selectedAddOns.length) return false;
      final itemAddOnIds = item.selectedAddOns.map((e) => e.id).toSet();
      final newAddOnIds = selectedAddOns.map((e) => e.id).toSet();
      return itemAddOnIds.containsAll(newAddOnIds);
    });

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _items.add(
        CartItemModel(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          food: food,
          quantity: quantity,
          selectedAddOns: selectedAddOns,
          specialInstructions: specialInstructions,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    if (_items.isEmpty) {
      clearPromo();
    }
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'RIMRID10' || cleanCode == 'WELCOME10') {
      _appliedPromoCode = cleanCode;
      _discountAmount = 5.00; // $5 off
      notifyListeners();
      return true;
    } else if (cleanCode == 'FREEDEL') {
      _appliedPromoCode = cleanCode;
      _discountAmount = deliveryFee;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearPromo() {
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    clearPromo();
    notifyListeners();
  }
}
