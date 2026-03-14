import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/utils/constants.dart';

class SplashViewModel extends ChangeNotifier {

  bool _showWelcome = false;
  bool get showWelcome => _showWelcome;
  final SettingsRepository settingsRepository = SettingsRepository();

  Future<void> initializeApp() async {

    await Future.delayed(const Duration(seconds: 1));
    String? firstRun = await settingsRepository.getSetting(Constants.settingsFirstRun);

    if (firstRun == null) {
      // It is first run.
      _showWelcome = true;
    }
    else {
      _showWelcome = false;
    }
    notifyListeners();
  }

}
