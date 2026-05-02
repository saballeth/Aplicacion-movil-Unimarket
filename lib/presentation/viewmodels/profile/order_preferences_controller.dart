import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPreferencesController extends ChangeNotifier {
  static const String _kShowOldOrders = 'order_pref_show_old_orders';
  static const String _kGroupByStore = 'order_pref_group_by_store';
  static const String _kNotifyEta = 'order_pref_notify_eta';

  final SharedPreferences preferences;

  bool showOldOrders = true;
  bool groupByStore = true;
  bool notifyEstimatedArrival = false;

  OrderPreferencesController(this.preferences);

  Future<void> load() async {
    showOldOrders = preferences.getBool(_kShowOldOrders) ?? showOldOrders;
    groupByStore = preferences.getBool(_kGroupByStore) ?? groupByStore;
    notifyEstimatedArrival =
        preferences.getBool(_kNotifyEta) ?? notifyEstimatedArrival;
    notifyListeners();
  }

  Future<void> setShowOldOrders(bool value) async {
    showOldOrders = value;
    await preferences.setBool(_kShowOldOrders, value);
    notifyListeners();
  }

  Future<void> setGroupByStore(bool value) async {
    groupByStore = value;
    await preferences.setBool(_kGroupByStore, value);
    notifyListeners();
  }

  Future<void> setNotifyEstimatedArrival(bool value) async {
    notifyEstimatedArrival = value;
    await preferences.setBool(_kNotifyEta, value);
    notifyListeners();
  }
}