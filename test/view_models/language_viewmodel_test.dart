import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
@GenerateMocks([SettingsRepository])
import 'language_viewmodel_test.mocks.dart';

void main() {

  late MockSettingsRepository mockRepo;
  late LanguageViewmodel viewModel;
  bool notified = false;

  setUp(() {
    mockRepo = MockSettingsRepository();
    viewModel = LanguageViewmodel(settingsRepo: mockRepo);
    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Language Screen", () {

    group("Loading language:", () {

      test("should load a language.", () async {
        when(mockRepo.getSetting(any)).thenAnswer((_) async => Constants.langEng);
        await viewModel.loadLanguage();
        expect(viewModel.locale, isA<Locale>());
        expect(notified, true);
      });

      test("should load a language even when no valid language provided.", () async {
        when(mockRepo.getSetting(any)).thenAnswer((_) async => null);
        await viewModel.loadLanguage();

        expect(viewModel.locale, isA<Locale>());
        expect(notified, true);
      });
    });

    group("Changing language:", () {

      test("should change the language.", () async {
        when(mockRepo.setSetting(any, any)).thenAnswer((_) async => Future.value());
        await viewModel.changeLanguage(Constants.langDe);

        expect(notified, true);
      });
    });
  });

}