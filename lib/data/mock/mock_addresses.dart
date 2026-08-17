import '../models/address_model.dart';

class MockAddresses {
  static List<AddressModel> addresses = const [
    AddressModel(
      id: 'addr_1',
      label: 'Home',
      fullAddress: '124 Grand Avenue, Apt 4B',
      details: 'Central District, Downtown, NY 10001',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr_2',
      label: 'Office',
      fullAddress: '88 Innovation Tech Park, Floor 3',
      details: 'West Silicon Highway, NY 10012',
      isDefault: false,
    ),
    AddressModel(
      id: 'addr_3',
      label: 'Parents House',
      fullAddress: '45 Sunset Boulevard, Villa 12',
      details: 'Green Valley Suburb, NY 10045',
      isDefault: false,
    ),
  ];
}
