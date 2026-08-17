import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String label; // e.g. Home, Office, Apartment
  final String fullAddress;
  final String details;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.details,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? details,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, label, fullAddress, details, isDefault];
}
