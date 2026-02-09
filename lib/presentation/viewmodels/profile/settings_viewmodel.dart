import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kNotifKey = 'settings_notifications';
const _kOrderPrefKey = 'settings_order_preferences';
const _kPrivacyKey = 'settings_privacy_security';
const _kAppPrefKey = 'settings_app_preferences';

class SettingsViewModel extends ChangeNotifier {
  bool notifications = true;
  bool orderPreferences = false;
  bool privacyAndSecurity = true;
  bool appPreferences = false;

  void toggleNotifications(bool v) {
    notifications = v;
    notifyListeners();
    _saveBool(_kNotifKey, v);
  }

  void toggleOrderPreferences(bool v) {
    orderPreferences = v;
    notifyListeners();
    _saveBool(_kOrderPrefKey, v);
  }

  void togglePrivacyAndSecurity(bool v) {
    privacyAndSecurity = v;
    notifyListeners();
    _saveBool(_kPrivacyKey, v);
  }

  void toggleAppPreferences(bool v) {
    appPreferences = v;
    notifyListeners();
    _saveBool(_kAppPrefKey, v);
  }

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    notifications = sp.getBool(_kNotifKey) ?? notifications;
    orderPreferences = sp.getBool(_kOrderPrefKey) ?? orderPreferences;
    privacyAndSecurity = sp.getBool(_kPrivacyKey) ?? privacyAndSecurity;
    appPreferences = sp.getBool(_kAppPrefKey) ?? appPreferences;
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
  }
}
