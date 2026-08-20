import 'package:flutter/foundation.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/datasources/remote/location_remote_data_source.dart';
import '../../../data/mock/mock_addresses.dart';
import '../../../data/models/address_model.dart';

class AddressSearchResult {
  final String shortAddress;
  final String details;

  const AddressSearchResult({required this.shortAddress, required this.details});
}

class AddressProvider extends ChangeNotifier {
  final LocationRemoteDataSource _locationRemoteDataSource;
  final List<AddressModel> _addresses = List.from(MockAddresses.addresses);

  bool _isSearching = false;

  AddressProvider({LocationRemoteDataSource? locationRemoteDataSource})
      : _locationRemoteDataSource = locationRemoteDataSource ?? LocationRemoteDataSource();

  List<AddressModel> get addresses => List.unmodifiable(_addresses);
  bool get isSearching => _isSearching;

  /// Real address search/autocomplete backed by OpenStreetMap Nominatim (free, keyless).
  Future<List<AddressSearchResult>> searchAddress(String query) async {
    if (query.trim().length < 3) return [];

    _isSearching = true;
    notifyListeners();

    try {
      AppLogger.info('AddressProvider', 'Searching address for "$query"');
      final results = await _locationRemoteDataSource.search(query);
      return results.map((item) {
        final displayName = (item['display_name'] ?? '').toString();
        final parts = displayName.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
        final shortAddress = parts.isNotEmpty ? parts.first : displayName;
        final details = parts.length > 1 ? parts.skip(1).join(', ') : '';
        return AddressSearchResult(shortAddress: shortAddress, details: details);
      }).toList();
    } catch (e) {
      AppLogger.error('AddressProvider', 'Address search failed: $e');
      return [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

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
