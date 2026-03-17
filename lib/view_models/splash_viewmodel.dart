import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/utils/constants.dart';

typedef DelayFunction = Future<void> Function(Duration);

class SplashViewModel extends ChangeNotifier {

  bool _showWelcome = false;
  bool get showWelcome => _showWelcome;
  final SettingsRepository settingsRepository;
  final DelayFunction delayFunction = Future.delayed;

  SplashViewModel({SettingsRepository? settingsRepo}) :
        settingsRepository = settingsRepo ?? SettingsRepository();

  Future<void> initializeApp(int delay) async {

    await delayFunction(Duration(seconds: delay));
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
