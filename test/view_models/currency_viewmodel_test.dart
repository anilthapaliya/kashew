import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/database/repositories/setting_repository.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SettingsRepository])
import 'currency_viewmodel_test.mocks.dart';

void main() {

  late MockSettingsRepository mockRepo;
  late CurrencyViewModel viewModel;
  bool notified = false;

  setUp(() {
    mockRepo = MockSettingsRepository();
    viewModel = CurrencyViewModel(settingsRepo: mockRepo);

    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Currency Screen", () {

    group("While loading a currency:", () {

      test("should load a currency.", () async {
        // Arrange
        when(mockRepo.getSetting(any)).thenAnswer((_) async => CurrencyModel.eur);
        // Act
        await viewModel.loadDefaultCurrency();
        // Assert
        expect(viewModel.defaultCurrency, isA<CurrencyModel>());
        expect(notified, true);
      });

      test("should load a default currency.", () async {
        // Arrange
        when(mockRepo.getSetting(any)).thenAnswer((_) async => null);
        // Act
        await viewModel.loadDefaultCurrency();
        // Assert
        expect(viewModel.defaultCurrency, isA<CurrencyModel>());
        expect(notified, true);
      });

      test("should load a default currency in case of random value.", () async {
        // Arrange
        when(mockRepo.getSetting(any)).thenAnswer((_) async => "random-currency");
        // Act
        await viewModel.loadDefaultCurrency();
        // Assert
        expect(viewModel.defaultCurrency, isA<CurrencyModel>());
        expect(notified, true);
      });
    });

    group("While setting a currency:", () {

      test("should set a currency.", () async {
        when(mockRepo.setSetting(any, any)).thenAnswer((_) async => Future.value());
        // Act
        viewModel.setDefaultCurrency(CurrencyModel(CurrencyModel.eur));
        // Assert
        expect(viewModel.defaultCurrency, isA<CurrencyModel>());
        expect(notified, true);
      });
    });
  });

}