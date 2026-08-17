import '../models/payment_method_model.dart';

class MockPayments {
  static List<PaymentMethodModel> paymentMethods = const [
    PaymentMethodModel(
      id: 'pay_1',
      type: PaymentType.visa,
      title: 'Visa Premium Card',
      lastFour: '4242',
      expiryDate: '12/28',
      isDefault: true,
    ),
    PaymentMethodModel(
      id: 'pay_2',
      type: PaymentType.mastercard,
      title: 'Mastercard Corporate',
      lastFour: '8899',
      expiryDate: '09/27',
      isDefault: false,
    ),
    PaymentMethodModel(
      id: 'pay_3',
      type: PaymentType.cod,
      title: 'Cash on Delivery',
      isDefault: false,
    ),
  ];
}
