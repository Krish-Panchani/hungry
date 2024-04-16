import 'package:flutter/material.dart';
import 'package:hunger/models/UserModal.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? _selectedUserData;

  UserData? get selectedUserData => _selectedUserData;

  void setSelectedUserData(UserData userData) {
    _selectedUserData = userData;
    notifyListeners();
  }
}
