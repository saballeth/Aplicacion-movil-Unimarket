import 'package:flutter/material.dart';

class EditProfileViewModel extends ChangeNotifier {
  String name;
  String email;
  String phone;

  EditProfileViewModel({
    this.name = 'Diego David Oñate Acuña',
    this.email = 'diegoonate3026@gmail.com',
    this.phone = '+57 (324) 213 7922',
  });

  void setName(String v) {
    name = v;
    notifyListeners();
  }

  void setEmail(String v) {
    email = v;
    notifyListeners();
  }

  void setPhone(String v) {
    phone = v;
    notifyListeners();
  }

  Map<String, String> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
