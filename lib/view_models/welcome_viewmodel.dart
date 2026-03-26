import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';

class WelcomeViewModel extends ChangeNotifier {

  final SettingsRepository settingsRepository;
  LanguageViewModel languageVM;
  CurrencyViewModel currencyVM;

  WelcomeViewModel({ SettingsRepository? settingsRepo,
    required this.languageVM, required this.currencyVM }) :
        settingsRepository = settingsRepo ?? SettingsRepository();

  Future<void> loadDefaults() async {
    await languageVM.changeLanguage(Constants.langEng);
    currencyVM.selectCurrency(currencyVM.defaultCurrency);
    notifyListeners();
  }

  Future<void> saveSettings() async {

    final language = languageVM.locale.languageCode;
    final currency = currencyVM.defaultCurrency.code;

    if (language.isNotEmpty && currency.isNotEmpty) {
      await settingsRepository.setSetting(Constants.settingsLanguage, language);
      await settingsRepository.setSetting(Constants.settingsCurrency, currency);
      await settingsRepository.setSetting(Constants.settingsFirstRun, "YES");
      return;
    }

    throw Exception("Language or Currency not set.");
  }

}