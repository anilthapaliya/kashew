import 'package:flutter/material.dart';
import 'package:kashew/models/currency_model.dart';

class CurrencyViewModel extends ChangeNotifier {

  final List<CurrencyModel> currencies = [
    CurrencyModel(CurrencyModel.npr),
    CurrencyModel(CurrencyModel.eur),
    CurrencyModel(CurrencyModel.usd),
    CurrencyModel(CurrencyModel.gbp),
    CurrencyModel(CurrencyModel.yen),
    CurrencyModel(CurrencyModel.xxx),
  ];

  CurrencyModel? defaultCurrency;

  CurrencyViewModel() {

    defaultCurrency = currencies[0];
    notifyListeners();
  }

  void selectCurrency(CurrencyModel model) {

    defaultCurrency = model;
    notifyListeners();
  }

}