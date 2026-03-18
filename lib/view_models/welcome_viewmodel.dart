import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';

class WelcomeViewModel extends ChangeNotifier {

  final SettingsRepository settingsRepository;
  LanguageModel? languageModel;
  CurrencyModel? currencyModel;

  WelcomeViewModel({ SettingsRepository? settingsRepo }) :
        settingsRepository = settingsRepo ?? SettingsRepository();

  void setLanguage(LanguageModel languageModel) {
    this.languageModel = languageModel;
  }

  void setCurrency(CurrencyModel currencyModel) {
    this.currencyModel = currencyModel;
  }

  Future<void> saveSettings() async {

    if (languageModel != null && currencyModel != null) {
      await settingsRepository.setSetting(Constants.settingsLanguage, languageModel!.code);
      await settingsRepository.setSetting(Constants.settingsCurrency, currencyModel!.code);
      await settingsRepository.setSetting(Constants.settingsFirstRun, "YES");
      return;
    }

    throw Exception("Language or Currency not set.");
  }

}