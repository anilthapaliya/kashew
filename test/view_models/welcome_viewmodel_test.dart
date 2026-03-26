import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/welcome_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../views/splash_screen_test.mocks.dart';
@GenerateMocks([SettingsRepository])
import 'welcome_viewmodel_test.mocks.dart';

void main() {

  late WelcomeViewModel viewModel;
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
    viewModel = WelcomeViewModel(settingsRepo: mockRepo, languageVM: MockLanguageViewModel(), currencyVM: MockCurrencyViewModel());
  });

  group("Welcome Screen", () {

    test("should save the settings", () async {
      // Arrange
      final lang = LanguageModel(code: "en", language: "English");
      final cur = CurrencyModel("USD");
      when(viewModel.currencyVM.defaultCurrency).thenReturn(cur);
      when(viewModel.languageVM.locale).thenReturn(Locale(lang.code));

      // Act
      await viewModel.saveSettings();

      // Assert
      verify(mockRepo.setSetting(Constants.settingsLanguage, "en")).called(1);
      verify(mockRepo.setSetting(Constants.settingsCurrency, "USD")).called(1);
      verify(mockRepo.setSetting(Constants.settingsFirstRun, "YES")).called(1);
    });

    test("should not save the settings", () async {
      when(viewModel.currencyVM.defaultCurrency).thenReturn(CurrencyModel(""));
      when(viewModel.languageVM.locale).thenReturn(Locale("en"));

      expect(viewModel.saveSettings(), throwsException);
      verifyNever(mockRepo.setSetting(any, any));
    });

  });

}

/*
To generate mock classes:
  dart run build_runner build
 */