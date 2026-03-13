import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/views/currency_only_list_screen.dart';
import 'package:kashew/views/home/home_screen.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:kashew/views/language_only_list_screen.dart';
import 'package:kashew/views/settings_screen.dart';
import 'package:kashew/views/splash_screen.dart';
import 'package:kashew/views/topic_detail_screen.dart';
import 'package:kashew/views/topic_only_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kashew/l10n/app_localizations.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => CurrencyViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => TopicViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => LanguageViewmodel()),
      ], child: const KashewApp())
  );
}

class KashewApp extends StatelessWidget {

  const KashewApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Initialize the Responsive class.
    R.init(context);

    return Consumer<LanguageViewmodel>(
        builder: (context, language, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: language.locale,
            routes: {
              Constants.home: (context) => const HomeScreen(),
              Constants.topicDetails: (context) => const TopicDetailScreen(),
              Constants.topicOnlyList: (context) => const TopicListScreen(),
              Constants.settings: (context) => const SettingsScreen(),
              Constants.currencyOnlyList: (context) => const CurrencyListScreen(),
              Constants.languageOnlyList: (context) => const LanguageListScreen(),
            },
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: Constants.fontBody,
            ),
            home: const SplashScreen(),
          );
        });
  }

}
