import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:mockito/mockito.dart';
@GenerateMocks([SettingsRepository])
import 'splash_viewmodel_test.mocks.dart';

void main() {

  late SplashViewModel viewModel;
  late MockSettingsRepository testRepo;
  bool notified = false;

  setUpAll(() {
    testRepo = MockSettingsRepository();
    viewModel = SplashViewModel(settingsRepo: testRepo);
    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Splash Screen", () {

    test("should show welcome screen on first launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => null);
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, true);
      expect(notified, true);
    });

    test("should show welcome screen on first launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => "");
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, false);
      expect(notified, true);
    });

    test("should show home screen on next launch.", () async {
      when(testRepo.getSetting(any)).thenAnswer((_) async => "any-value-works");
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, false);
      expect(notified, true);
    });
  });

}
