import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';

class WelcomeViewModel extends ChangeNotifier {

  final SettingsRepository settingsRepo = SettingsRepository();
  LanguageModel? languageModel;
  CurrencyModel? currencyModel;

  void setLanguage(LanguageModel languageModel) {
    this.languageModel = languageModel;
  }

  void setCurrency(CurrencyModel currencyModel) {
    this.currencyModel = currencyModel;
  }

  Future<void> saveSettings() async {

    await settingsRepo.setSetting(Constants.settingsLanguage, languageModel!.code);
    await settingsRepo.setSetting(Constants.settingsCurrency, currencyModel!.code);
    await settingsRepo.setSetting(Constants.settingsFirstRun, "YES");
  }

}