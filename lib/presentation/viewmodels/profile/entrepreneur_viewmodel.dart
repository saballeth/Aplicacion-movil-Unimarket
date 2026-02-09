import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kEntrepreneurRequestsKey = 'entrepreneur_requests';

class EntrepreneurViewModel extends ChangeNotifier {
  String businessName = '';
  String ownerName = '';
  String category = 'Alimentos';
  String phone = '';
  String address = '';
  String description = '';
  bool acceptedTerms = false;
  bool submitting = false;

  final List<String> categories = [
    'Alimentos',
    'Ropa',
    'Electrónica',
    'Hogar',
    'Belleza',
    'Otros',
  ];

  void setBusinessName(String v) {
    businessName = v;
    notifyListeners();
  }

  void setOwnerName(String v) {
    ownerName = v;
    notifyListeners();
  }

  void setCategory(String v) {
    category = v;
    notifyListeners();
  }

  void setPhone(String v) {
    phone = v;
    notifyListeners();
  }

  void setAddress(String v) {
    address = v;
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    notifyListeners();
  }

  void setAcceptedTerms(bool v) {
    acceptedTerms = v;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (businessName.isEmpty || ownerName.isEmpty || phone.isEmpty || !acceptedTerms) return false;
    submitting = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    // Simulated backend: persist request list in SharedPreferences as JSON strings
    try {
      final sp = await SharedPreferences.getInstance();
      final existing = sp.getStringList(_kEntrepreneurRequestsKey) ?? <String>[];
      final timestamp = DateTime.now().toIso8601String();
      final record = jsonEncode({
        'id': 'REQ_$timestamp',
        'businessName': businessName,
        'ownerName': ownerName,
        'category': category,
        'phone': phone,
        'address': address,
        'description': description,
        'acceptedTerms': acceptedTerms,
        'createdAt': timestamp,
      });
      existing.add(record);
      await sp.setStringList(_kEntrepreneurRequestsKey, existing);
    } catch (_) {
      // ignore storage errors for simulation
    }

    submitting = false;
    notifyListeners();
    return true;
  }
}
