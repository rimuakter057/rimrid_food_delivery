import 'package:equatable/equatable.dart';

enum PaymentType { visa, mastercard, cod }

class PaymentMethodModel extends Equatable {
  final String id;
  final PaymentType type;
  final String title;
  final String? lastFour;
  final String? expiryDate;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.title,
    this.lastFour,
    this.expiryDate,
    this.isDefault = false,
  });

  PaymentMethodModel copyWith({
    String? id,
    PaymentType? type,
    String? title,
    String? lastFour,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      lastFour: lastFour ?? this.lastFour,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, type, title, lastFour, expiryDate, isDefault];
}
