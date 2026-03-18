import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';

import '../database/repositories/setting_repository_test.dart';

void main() {

  late SplashViewModel viewModel;
  late TestSettingsRepository testRepo;
  bool notified = false;

  setUpAll(() {
    testRepo = TestSettingsRepository(value: "test");
    viewModel = SplashViewModel(settingsRepo: testRepo);
    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Splash Screen", () {
    test("should show welcome screen on first launch.", () async {
      testRepo.value = null;
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, true);
      expect(notified, true);
    });
    test("should show welcome screen on first launch.", () async {
      testRepo.value = "";
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, false);
      expect(notified, true);
    });

    test("should show home screen on next launch.", () async {
      testRepo.value = "any-value-works";
      await viewModel.initializeApp(0);
      expect(viewModel.showWelcome, false);
      expect(notified, true);
    });
  });

}
