import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user-models.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Userm? _user;
  final AuthMethods _authMethods = AuthMethods();

  Userm? get getUser => _user;

  Future<void> refreshUser() async {
    // print("REFRESH USER CALLEDDD");

    Userm user = await _authMethods.getUserInfo();
    _user = user;
    notifyListeners();

    // print("##############LEAVING REFRESH USER SUCCEDDFULLY");
  }
}
