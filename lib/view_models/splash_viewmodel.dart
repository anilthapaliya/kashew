import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {

  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> initializeApp() async {

    await Future.delayed(const Duration(seconds: 1));
    _initialized = true;
    notifyListeners();
  }

}
