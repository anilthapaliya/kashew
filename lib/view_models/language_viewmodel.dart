import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';

class LanguageViewmodel extends ChangeNotifier {

  SettingsRepository settingsRepo;
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  List<LanguageModel> languages = [
    LanguageModel(code: Constants.langEng, language: 'English'),
    LanguageModel(code: Constants.langDe, language: 'Deutsch'),
    LanguageModel(code: Constants.langEs, language: 'Espanol'),
  ];

  LanguageViewmodel({ SettingsRepository? settingsRepo}) :
      settingsRepo = settingsRepo ??= SettingsRepository();

  LanguageModel getLanguage(String code) {

    return languages.firstWhere((element) => element.code == code);
  }

  Future<void> loadLanguage() async {

    String? language = await settingsRepo.getSetting(Constants.settingsLanguage);
    if (language == null) {
      _locale = Locale(Constants.langEng);
    } else {
      _locale = Locale(language);
    }

    notifyListeners();
  }

  Future<void> changeLanguage(String code) async {

    await settingsRepo.setSetting(Constants.settingsLanguage, code);
    _locale = Locale(code);
    notifyListeners();
  }

}