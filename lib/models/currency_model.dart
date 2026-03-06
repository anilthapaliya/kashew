import 'package:flutter/material.dart';

class CurrencyModel {

  String code;
  String? currency;
  IconData? symbol;

  CurrencyModel._(this.code, this.currency, this.symbol);

  factory CurrencyModel(String code) {
    return CurrencyModel._(
      code,
      currencyMap[code] ?? currencyMap[xxx],
      iconMap[code] ?? iconMap[xxx],
    );
  }

  static final Map<String, IconData> iconMap = {
    eur: Icons.euro,
    usd: Icons.attach_money,
    gbp: Icons.currency_pound,
    yen: Icons.currency_yen,
    xxx: Icons.payments
  };

  static final Map<String, String> currencyMap = {
    eur: "Euro",
    usd: "US Dollar",
    gbp: "GBP",
    yen: "Yen",
    npr: "NRs",
    xxx: "XXX"
  };

  static final String eur = "EUR";
  static final String usd = "USD";
  static final String gbp = "GBP";
  static final String npr = "NPR";
  static final String yen = "YEN";
  static final String xxx = "XXX";

}