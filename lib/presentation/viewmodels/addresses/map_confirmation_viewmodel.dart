import 'package:flutter/foundation.dart';

class MapConfirmationViewModel extends ChangeNotifier {
  String mainAddress;
  String details;
  String description;

  MapConfirmationViewModel({required String initialMain})
      : mainAddress = initialMain,
        details = '',
        description = '';

  void setMain(String v) {
    mainAddress = v;
    notifyListeners();
  }

  void setDetails(String v) {
    details = v;
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    notifyListeners();
  }
}
