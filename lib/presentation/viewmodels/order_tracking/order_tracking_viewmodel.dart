import 'package:flutter/foundation.dart';

class TimelineStep {
  final String title;
  final String subtitle;
  bool isActive;
  bool isCompleted;

  TimelineStep({
    required this.title,
    required this.subtitle,
    this.isActive = false,
    this.isCompleted = false,
  });
}

class OrderTrackingViewModel extends ChangeNotifier {
  String restaurantName = 'Jeikol Pizza';
  bool isDeliverySelected = true;

  final List<TimelineStep> steps = [
    TimelineStep(title: 'Línea 1', subtitle: '9th St', isActive: true, isCompleted: true),
    TimelineStep(title: '', subtitle: '95th St', isActive: true, isCompleted: true),
    TimelineStep(title: '', subtitle: '2nd Ave', isActive: true, isCompleted: true),
    TimelineStep(title: '', subtitle: '8th Street', isActive: true, isCompleted: false),
    TimelineStep(title: 'Jeikol Pizza', subtitle: 'Pizzas', isActive: false, isCompleted: false),
  ];

  void toggleDelivery(bool delivery) {
    isDeliverySelected = delivery;
    notifyListeners();
  }

  void setStepCompleted(int index, bool completed) {
    if (index >= 0 && index < steps.length) {
      steps[index].isCompleted = completed;
      notifyListeners();
    }
  }
}
