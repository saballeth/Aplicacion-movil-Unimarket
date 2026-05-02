import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySecurityController extends ChangeNotifier {
  static const String _kPublicProfile = 'privacy_public_profile';
  static const String _kShowLocation = 'privacy_show_location';
  static const String _kAllowContact = 'privacy_allow_contact';
  static const String _kTwoFactor = 'privacy_two_factor';

  final SharedPreferences preferences;

  bool publicProfile = false;
  bool showLocation = true;
  bool allowContact = true;
  bool twoFactorAuthentication = false;

  PrivacySecurityController(this.preferences);

  Future<void> load() async {
    publicProfile = preferences.getBool(_kPublicProfile) ?? publicProfile;
    showLocation = preferences.getBool(_kShowLocation) ?? showLocation;
    allowContact = preferences.getBool(_kAllowContact) ?? allowContact;
    twoFactorAuthentication =
        preferences.getBool(_kTwoFactor) ?? twoFactorAuthentication;
    notifyListeners();
  }

  Future<void> setPublicProfile(bool value) async {
    publicProfile = value;
    await preferences.setBool(_kPublicProfile, value);
    notifyListeners();
  }

  Future<void> setShowLocation(bool value) async {
    showLocation = value;
    await preferences.setBool(_kShowLocation, value);
    notifyListeners();
  }

  Future<void> setAllowContact(bool value) async {
    allowContact = value;
    await preferences.setBool(_kAllowContact, value);
    notifyListeners();
  }

  Future<void> setTwoFactorAuthentication(bool value) async {
    twoFactorAuthentication = value;
    await preferences.setBool(_kTwoFactor, value);
    notifyListeners();
  }
}