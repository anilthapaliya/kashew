import 'package:flutter/material.dart';
import 'package:kashew/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get lang => AppLocalizations.of(this)!;
}