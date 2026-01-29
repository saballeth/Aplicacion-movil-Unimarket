import 'package:flutter/foundation.dart';
import 'addresses_viewmodel.dart';

class AddAddressViewModel extends ChangeNotifier {
  String mainAddress;
  String secondaryAddress;
  String description;
  bool isDefault;

  AddAddressViewModel({Address? initial})
      : mainAddress = initial?.mainAddress ?? '',
        secondaryAddress = initial?.secondaryAddress ?? '',
        description = '',
        isDefault = initial?.isDefault ?? false;

  void setMain(String v) {
    mainAddress = v;
    notifyListeners();
  }

  void setSecondary(String v) {
    secondaryAddress = v;
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    notifyListeners();
  }

  void setDefault(bool v) {
    isDefault = v;
    notifyListeners();
  }

  Address buildAddress({String? id}) {
    return Address(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      mainAddress: mainAddress.trim(),
      secondaryAddress: secondaryAddress.trim(),
      isDefault: isDefault,
    );
  }
}
