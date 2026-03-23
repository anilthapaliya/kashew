import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';

typedef DelayFunction = Future<void> Function(Duration);

class SplashViewModel extends ChangeNotifier {

  final LanguageViewModel languageVM;
  final CurrencyViewModel currencyVM;
  final SettingsRepository settingsRepository;
  final DelayFunction delayFunction = Future.delayed;

  SplashViewModel({SettingsRepository? settingsRepo,
    required this.languageVM, required this.currencyVM}) :
        settingsRepository = settingsRepo ?? SettingsRepository();

  Future<String> initializeApp(int delay) async {

    await languageVM.loadLanguage();
    await currencyVM.loadDefaultCurrency();
    await delayFunction(Duration(seconds: delay));
    String? firstRun = await settingsRepository.getSetting(Constants.settingsFirstRun);

    return firstRun == null ? Constants.welcome : Constants.home;
  }

}
