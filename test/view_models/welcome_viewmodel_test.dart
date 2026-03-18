import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/welcome_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SettingsRepository])
import 'welcome_viewmodel_test.mocks.dart';

void main() {

  late WelcomeViewModel viewModel;
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
    viewModel = WelcomeViewModel(settingsRepo: mockRepo);
  });

  group("Welcome Screen", () {

    test("should save the settings", () async {
      // Arrange
      final lang = LanguageModel(code: "en", language: "English");
      viewModel.setLanguage(lang);
      final cur = CurrencyModel("USD");
      viewModel.setCurrency(cur);

      // Act
      when(mockRepo.setSetting(any, any)).thenAnswer((_) async => {});
      await viewModel.saveSettings();

      // Assert
      verify(mockRepo.setSetting(Constants.settingsLanguage, "en")).called(1);
      verify(mockRepo.setSetting(Constants.settingsCurrency, "USD")).called(1);
      verify(mockRepo.setSetting(Constants.settingsFirstRun, "YES")).called(1);
    });

    test("should not save the settings", () async {
      when(mockRepo.setSetting(any, any)).thenAnswer((_) async => {});

      expect(() async => await viewModel.saveSettings(), throwsException);
      verifyNever(mockRepo.setSetting(Constants.settingsLanguage, "en"));
      verifyNever(mockRepo.setSetting(Constants.settingsCurrency, "USD"));
      verifyNever(mockRepo.setSetting(Constants.settingsFirstRun, "YES"));
    });

    test("should throw exception", () async {
      when(mockRepo.setSetting(any, any)).thenThrow(Exception());

      expect(() async => await viewModel.saveSettings(), throwsException);
    });
  });

}

/*
To generate mock classes:
  dart run build_runner build
 */