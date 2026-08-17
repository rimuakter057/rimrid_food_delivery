import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_payments.dart';
import '../../../data/models/payment_method_model.dart';

class PaymentProvider extends ChangeNotifier {
  final List<PaymentMethodModel> _paymentMethods = List.from(MockPayments.paymentMethods);

  List<PaymentMethodModel> get paymentMethods => List.unmodifiable(_paymentMethods);

  PaymentMethodModel get selectedPaymentMethod {
    return _paymentMethods.firstWhere(
      (p) => p.isDefault,
      orElse: () => _paymentMethods.isNotEmpty
          ? _paymentMethods.first
          : const PaymentMethodModel(
              id: 'def',
              type: PaymentType.cod,
              title: 'Cash on Delivery',
              isDefault: true,
            ),
    );
  }

  void setDefaultPaymentMethod(String id) {
    for (var i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i].copyWith(isDefault: _paymentMethods[i].id == id);
    }
    notifyListeners();
  }

  void addPaymentMethod({
    required PaymentType type,
    required String title,
    String? lastFour,
    String? expiryDate,
    bool isDefault = false,
  }) {
    final newPayment = PaymentMethodModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      title: title,
      lastFour: lastFour,
      expiryDate: expiryDate,
      isDefault: isDefault || _paymentMethods.isEmpty,
    );

    if (newPayment.isDefault) {
      for (var i = 0; i < _paymentMethods.length; i++) {
        _paymentMethods[i] = _paymentMethods[i].copyWith(isDefault: false);
      }
    }

    _paymentMethods.add(newPayment);
    notifyListeners();
  }

  void deletePaymentMethod(String id) {
    _paymentMethods.removeWhere((p) => p.id == id);
    if (_paymentMethods.isNotEmpty && !_paymentMethods.any((p) => p.isDefault)) {
      _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }
}
