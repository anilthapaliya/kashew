import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KASHew'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'V1.0.0'**
  String get appVersion;

  /// No description provided for @lblAppBarHome.
  ///
  /// In en, this message translates to:
  /// **'My Expenses'**
  String get lblAppBarHome;

  /// No description provided for @lblAppBarAddTopic.
  ///
  /// In en, this message translates to:
  /// **'Create New Topic'**
  String get lblAppBarAddTopic;

  /// No description provided for @lblAppBarEditTopic.
  ///
  /// In en, this message translates to:
  /// **'Edit Topic'**
  String get lblAppBarEditTopic;

  /// No description provided for @lblAppBarAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get lblAppBarAddExpense;

  /// No description provided for @lblAppBarSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get lblAppBarSave;

  /// No description provided for @lblAppBarTopicList.
  ///
  /// In en, this message translates to:
  /// **'All Topics'**
  String get lblAppBarTopicList;

  /// No description provided for @lblAppBarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get lblAppBarSettings;

  /// No description provided for @lblAppBarCurrencyList.
  ///
  /// In en, this message translates to:
  /// **'All Currencies'**
  String get lblAppBarCurrencyList;

  /// No description provided for @lblAppBarLanguageList.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get lblAppBarLanguageList;

  /// No description provided for @lblLanguage.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get lblLanguage;

  /// No description provided for @lblCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get lblCurrencies;

  /// No description provided for @lblSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Expense Tracker'**
  String get lblSubtitle;

  /// No description provided for @lblTotalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get lblTotalExpense;

  /// No description provided for @lblMonthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get lblMonthlyExpense;

  /// No description provided for @lblTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get lblTopics;

  /// No description provided for @lblRecentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent Expenses'**
  String get lblRecentExpenses;

  /// No description provided for @lblViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get lblViewAll;

  /// No description provided for @lblSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get lblSettings;

  /// No description provided for @lblTopicName.
  ///
  /// In en, this message translates to:
  /// **'Topic Name'**
  String get lblTopicName;

  /// No description provided for @lblStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get lblStartDate;

  /// No description provided for @lblOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get lblOptional;

  /// No description provided for @lblDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get lblDescription;

  /// No description provided for @lblTopicHelp.
  ///
  /// In en, this message translates to:
  /// **'Topics help you organize your budget and expenses effortlessly.'**
  String get lblTopicHelp;

  /// No description provided for @lblCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get lblCurrency;

  /// No description provided for @lblExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get lblExpenseTitle;

  /// No description provided for @lblExpenses.
  ///
  /// In en, this message translates to:
  /// **'All Expenses'**
  String get lblExpenses;

  /// No description provided for @lblExpenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get lblExpenseAmount;

  /// No description provided for @lblCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get lblCategory;

  /// No description provided for @lblNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get lblNotes;

  /// No description provided for @lblDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get lblDate;

  /// No description provided for @lblTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get lblTopic;

  /// No description provided for @lblNoTopics.
  ///
  /// In en, this message translates to:
  /// **'No topics found!'**
  String get lblNoTopics;

  /// No description provided for @lblNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get lblNoExpenses;

  /// No description provided for @lblPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get lblPreferences;

  /// No description provided for @lblAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get lblAppearance;

  /// No description provided for @lblCurrencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency Settings'**
  String get lblCurrencySettings;

  /// No description provided for @lblAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get lblAboutApp;

  /// No description provided for @lblHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get lblHelpSupport;

  /// No description provided for @btnCreateTopic.
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get btnCreateTopic;

  /// No description provided for @btnAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get btnAddExpense;

  /// No description provided for @menuEditTopic.
  ///
  /// In en, this message translates to:
  /// **'Edit Topic'**
  String get menuEditTopic;

  /// No description provided for @menuDeleteTopic.
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get menuDeleteTopic;

  /// No description provided for @hintTopic.
  ///
  /// In en, this message translates to:
  /// **'e.g., Trek to ABC'**
  String get hintTopic;

  /// No description provided for @hintDescription.
  ///
  /// In en, this message translates to:
  /// **'What\'s this topic about?'**
  String get hintDescription;

  /// No description provided for @hintToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get hintToday;

  /// No description provided for @hintExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'What did you spend on?'**
  String get hintExpenseTitle;

  /// No description provided for @hintNotes.
  ///
  /// In en, this message translates to:
  /// **'Add remarks or receipt details.'**
  String get hintNotes;

  /// No description provided for @hintAmount.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get hintAmount;

  /// No description provided for @hintLinkTopic.
  ///
  /// In en, this message translates to:
  /// **'Link to a topic'**
  String get hintLinkTopic;

  /// No description provided for @dialogTopicDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get dialogTopicDeleteTitle;

  /// No description provided for @dialogTopicDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this topic?\nAll related expenses will also be removed.'**
  String get dialogTopicDeleteMessage;

  /// No description provided for @dialogDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDeleteConfirm;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogExpenseDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get dialogExpenseDeleteTitle;

  /// No description provided for @dialogExpenseDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense entry?'**
  String get dialogExpenseDeleteMessage;

  /// No description provided for @errTopicName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a suitable topic.'**
  String get errTopicName;

  /// No description provided for @errExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a suitable title.'**
  String get errExpenseTitle;

  /// No description provided for @errExpenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get errExpenseAmount;

  /// No description provided for @lblWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to KASHew App'**
  String get lblWelcome;

  /// No description provided for @lblWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you set up in a quick few steps.'**
  String get lblWelcomeMessage;

  /// No description provided for @lblSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your Language'**
  String get lblSelectLanguage;

  /// No description provided for @lblSelectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select your Currency'**
  String get lblSelectCurrency;

  /// No description provided for @btnGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get btnGetStarted;

  /// No description provided for @lblTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms of Service and Privacy Policy.'**
  String get lblTermsOfService;

  /// No description provided for @lblTopCategory.
  ///
  /// In en, this message translates to:
  /// **'Top Category'**
  String get lblTopCategory;

  /// No description provided for @lblThisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get lblThisMonth;

  /// No description provided for @tooltipKUnit.
  ///
  /// In en, this message translates to:
  /// **'kU (Kashew Unit) is an internal unit that sums expenses from different currencies. It represents spending activity, not real money.'**
  String get tooltipKUnit;

  /// No description provided for @snackFailToSave.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the settings.'**
  String get snackFailToSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
