import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:mockito/mockito.dart';
import '../views/splash_screen_test.mocks.dart';
@GenerateMocks([SettingsRepository])
import 'splash_viewmodel_test.mocks.dart';

void main() {

  late SplashViewModel viewModel;
  late MockSettingsRepository testRepo;

  setUpAll(() {
    testRepo = MockSettingsRepository();
    viewModel = SplashViewModel(settingsRepo: testRepo, currencyVM: MockCurrencyViewModel(), languageVM: MockLanguageViewModel());
  });

  group("Splash Screen", () {

    test("should show welcome screen on first launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => null);
      final result = await viewModel.initializeApp(0);
      expect(result, Constants.welcome);
    });

    test("should show welcome screen on first launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => "");
      final result = await viewModel.initializeApp(0);
      expect(result, Constants.home);
    });

    test("should show home screen on next launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => "any-value-works");
      final result = await viewModel.initializeApp(0);
      expect(result, Constants.home);
    });
  });

}
