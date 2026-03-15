import 'package:flutter/material.dart';

class CurrencyModel {

  String code;
  String? currency;
  IconData? symbol;
  static final IconData fallbackIcon = Icons.payments;

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
    inr: Icons.currency_rupee,
    aud: Icons.attach_money,
    npr: fallbackIcon,
    xxx: fallbackIcon
  };

  static final Map<String, String> currencyMap = {
    eur: "Euro",
    usd: "US Dollar",
    gbp: "Pound Sterling",
    yen: "Yen",
    npr: "Rs",
    inr: "Rupee",
    aud: "Australian Dollar",
    xxx: "XXX"
  };

  static final String eur = "EUR";
  static final String usd = "USD";
  static final String gbp = "GBP";
  static final String yen = "YEN";
  static final String npr = "NPR";
  static final String inr = "INR";
  static final String aud = "AUD";
  static final String xxx = "XXX";

}