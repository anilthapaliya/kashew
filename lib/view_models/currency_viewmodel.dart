import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/settings_model.dart';
import 'package:kashew/utils/constants.dart';

class CurrencyViewModel extends ChangeNotifier {

  final SettingsRepository settingsRepo = SettingsRepository();
  final List<CurrencyModel> currencies = [
    CurrencyModel(CurrencyModel.npr),
    CurrencyModel(CurrencyModel.eur),
    CurrencyModel(CurrencyModel.usd),
    CurrencyModel(CurrencyModel.gbp),
    CurrencyModel(CurrencyModel.yen),
    CurrencyModel(CurrencyModel.inr),
    CurrencyModel(CurrencyModel.aud),
    CurrencyModel(CurrencyModel.xxx),
  ];

  late CurrencyModel defaultCurrency;

  CurrencyViewModel() {

    defaultCurrency = currencies[0];
    notifyListeners();
  }

  Future<void> loadDefaultCurrency() async {

    String? value = await settingsRepo.getSetting(Constants.settingsCurrency);

    if (value != null) {
      defaultCurrency = currencies.firstWhere((element) => element.code == value);
    } else {
      defaultCurrency = currencies[0];
    }

    notifyListeners();
  }

  void setDefaultCurrency(CurrencyModel model) {

    defaultCurrency = model;
    settingsRepo.setSetting(Constants.settingsCurrency, model.code);
    notifyListeners();
  }

  void selectCurrency(CurrencyModel model) {

    defaultCurrency = model;
    notifyListeners();
  }

  CurrencyModel getCurrencyFromCode(String code) {

    return currencies.firstWhere((element) => element.code == code);
  }

}