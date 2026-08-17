import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_addresses.dart';
import '../../../data/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final List<AddressModel> _addresses = List.from(MockAddresses.addresses);

  List<AddressModel> get addresses => List.unmodifiable(_addresses);

  AddressModel get selectedAddress {
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.isNotEmpty
          ? _addresses.first
          : const AddressModel(
              id: 'def',
              label: 'Home',
              fullAddress: 'Select an address',
              details: '',
            ),
    );
  }

  void setDefaultAddress(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    notifyListeners();
  }

  void addAddress({
    required String label,
    required String fullAddress,
    required String details,
    bool isDefault = false,
  }) {
    final newAddress = AddressModel(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      fullAddress: fullAddress,
      details: details,
      isDefault: isDefault || _addresses.isEmpty,
    );

    if (newAddress.isDefault) {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }

    _addresses.add(newAddress);
    notifyListeners();
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }
}
