import 'package:flutter/foundation.dart';

class OrderConfirmationViewModel extends ChangeNotifier {
  String title = '¡Pedido confirmado!';
  String subtitle = 'Tu compra se ha realizado exitosamente.';

  // In a real app you might hold the order id, tracking id, etc.
  void reset() {
    // Placeholder for any cleanup logic
    notifyListeners();
  }
}
