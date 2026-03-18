// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KASHew';

  @override
  String get appVersion => 'V1.0.0';

  @override
  String get lblAppBarHome => 'My Expenses';

  @override
  String get lblAppBarAddTopic => 'Create New Topic';

  @override
  String get lblAppBarEditTopic => 'Edit Topic';

  @override
  String get lblAppBarAddExpense => 'Add Expense';

  @override
  String get lblAppBarSave => 'Save';

  @override
  String get lblAppBarTopicList => 'All Topics';

  @override
  String get lblAppBarSettings => 'Settings';

  @override
  String get lblAppBarCurrencyList => 'All Currencies';

  @override
  String get lblAppBarLanguageList => 'All Languages';

  @override
  String get lblLanguage => 'Languages';

  @override
  String get lblCurrencies => 'Currencies';

  @override
  String get lblSubtitle => 'Personal Expense Tracker';

  @override
  String get lblTotalExpense => 'Total Expense';

  @override
  String get lblMonthlyExpense => 'Monthly Expense';

  @override
  String get lblTopics => 'Topics';

  @override
  String get lblRecentExpenses => 'Recent Expenses';

  @override
  String get lblViewAll => 'View All';

  @override
  String get lblSettings => 'Settings';

  @override
  String get lblTopicName => 'Topic Name';

  @override
  String get lblStartDate => 'Start Date';

  @override
  String get lblOptional => 'Optional';

  @override
  String get lblDescription => 'Description';

  @override
  String get lblTopicHelp =>
      'Topics help you organize your budget and expenses effortlessly.';

  @override
  String get lblCurrency => 'Currency';

  @override
  String get lblExpenseTitle => 'Title';

  @override
  String get lblExpenses => 'All Expenses';

  @override
  String get lblExpenseAmount => 'Amount';

  @override
  String get lblCategory => 'Category';

  @override
  String get lblNotes => 'Notes';

  @override
  String get lblDate => 'Date';

  @override
  String get lblTopic => 'Topic';

  @override
  String get lblNoTopics => 'No topics found!';

  @override
  String get lblNoExpenses => 'No expenses';

  @override
  String get lblPreferences => 'Preferences';

  @override
  String get lblAppearance => 'Appearance';

  @override
  String get lblCurrencySettings => 'Currency Settings';

  @override
  String get lblAboutApp => 'About App';

  @override
  String get lblHelpSupport => 'Help & Support';

  @override
  String get btnCreateTopic => 'Create Topic';

  @override
  String get btnAddExpense => 'Add Expense';

  @override
  String get menuEditTopic => 'Edit Topic';

  @override
  String get menuDeleteTopic => 'Delete Topic';

  @override
  String get hintTopic => 'e.g., Trek to ABC';

  @override
  String get hintDescription => 'What\'s this topic about?';

  @override
  String get hintToday => 'Today';

  @override
  String get hintExpenseTitle => 'What did you spend on?';

  @override
  String get hintNotes => 'Add remarks or receipt details.';

  @override
  String get hintAmount => '0.00';

  @override
  String get hintLinkTopic => 'Link to a topic';

  @override
  String get dialogTopicDeleteTitle => 'Delete Topic';

  @override
  String get dialogTopicDeleteMessage =>
      'Are you sure you want to delete this topic?\nAll related expenses will also be removed.';

  @override
  String get dialogDeleteConfirm => 'Delete';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogExpenseDeleteTitle => 'Delete Expense';

  @override
  String get dialogExpenseDeleteMessage =>
      'Are you sure you want to delete this expense entry?';

  @override
  String get errTopicName => 'Please enter a suitable topic.';

  @override
  String get errExpenseTitle => 'Please enter a suitable title.';

  @override
  String get errExpenseAmount => 'Please enter a valid amount.';

  @override
  String get lblWelcome => 'Welcome to KASHew App';

  @override
  String get lblWelcomeMessage => 'Let\'s get you set up in a quick few steps.';

  @override
  String get lblSelectLanguage => 'Select your Language';

  @override
  String get lblSelectCurrency => 'Select your Currency';

  @override
  String get btnGetStarted => 'Get Started';

  @override
  String get lblTermsOfService =>
      'By continuing you agree to our Terms of Service and Privacy Policy.';

  @override
  String get lblTopCategory => 'Top Category';

  @override
  String get lblThisMonth => 'this month';

  @override
  String get tooltipKUnit =>
      'kU (Kashew Unit) is an internal unit that sums expenses from different currencies. It represents spending activity, not real money.';

  @override
  String get snackFailToSave => 'Unable to save the settings.';
}
