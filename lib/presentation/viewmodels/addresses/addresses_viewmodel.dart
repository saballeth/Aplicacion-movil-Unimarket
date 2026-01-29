import 'package:flutter/foundation.dart';

class Address {
  final String id;
  String mainAddress;
  String secondaryAddress;
  bool isDefault;

  Address({
    required this.id,
    required this.mainAddress,
    required this.secondaryAddress,
    this.isDefault = false,
  });
}

class AddressesViewModel extends ChangeNotifier {
  final List<Address> addresses = [
    Address(
      id: '1',
      mainAddress: 'Manzana K casa 6, Garagoa',
      secondaryAddress: 'Calle 29',
      isDefault: false,
    ),
    Address(
      id: '2',
      mainAddress: 'Hangare A, Unimag',
      secondaryAddress: 'Atras de tableros',
      isDefault: true,
    ),
  ];

  int selectedIndex = 1;

  void select(int index) {
    if (index >= 0 && index < addresses.length) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void addAddress(Address a) {
    addresses.add(a);
    notifyListeners();
  }

  void editAddress(Address updated) {
    final i = addresses.indexWhere((e) => e.id == updated.id);
    if (i >= 0) {
      addresses[i] = updated;
      notifyListeners();
    }
  }

  void setDefaultById(String id) {
    for (final a in addresses) {
      a.isDefault = a.id == id;
    }
    notifyListeners();
  }
}
