import 'package:kashew/models/category_model.dart';

class Constants {

  static final String appTitle = 'KASHew';
  static final String appVersion = "V1.0.0";

  // Navigation Routes
  static final String splash = "/";
  static final String home = "/home";
  static final String topicDetails = "/topic-details";
  static final String expenseDetails = "/expense-details";
  static final String settings = "/settings";
  static final String topicOnlyList = "/topic-only-list";

  // App Images
  static final String imgLogo = "assets/images/kashew_logo.png";

  // App Labels
  static final String lblAppBarHome = "My Expenses";
  static final String lblAppBarAddTopic = "Create New Topic";
  static final String lblAppBarEditTopic = "Edit Topic";
  static final String lblAppBarAddExpense = "Add Expense";
  static final String lblAppBarSave = "Save";
  static final String lblAppBarTopicList = "All Topics";
  static final String lblSubtitle = "Personal Expense Tracker";
  static final String lblTotalExpense = "Total Expense";
  static final String lblMonthlyExpense = "Monthly Expense";
  static final String lblTopics = "Topics";
  static final String lblRecentExpenses = "Recent Expenses";
  static final String lblViewAll = "View All";
  static final String lblSettings = "Settings";
  static final String lblTopicName = "Topic Name";
  static final String lblStartDate = "Start Date";
  static final String lblOptional = "Optional";
  static final String lblDescription = "Description";
  static final String lblTopicHelp = "Topics help you organize your budget and expenses effortlessly.";
  static final String lblCurrency = "Currency";
  static final String lblExpenseTitle = "Title";
  static final String lblExpenses = "All Expenses";
  static final String lblExpenseAmount = "Amount";
  static final String lblCategory = "Category";
  static final String lblNotes = "Notes";
  static final String lblDate = "Date";
  static final String lblTopic = "Topic";
  static final String lblNoTopics = "No topics found!";
  static final String lblNoExpenses = "No expenses";

  static final String btnCreateTopic = "Create Topic";
  static final String btnAddExpense = "Add Expense";

  static final String menuEditTopic = "Edit Topic";
  static final String menuDeleteTopic = "Delete Topic";

  static final String hintTopic =  "e.g., Trek to ABC";
  static final String hintDescription = "What's this topic about?";
  static final String hintToday = "Today";
  static final String hintExpenseTitle = "What did you spend on?";
  static final String hintNotes = "Add remarks or receipt details.";
  static final String hintAmount = "0.00";
  static final String hintLinkTopic = "Link to a topic";

  static final String dialogDeleteTitle = "Delete Topic";
  static final String dialogDeleteMessage = "Are you sure you want to delete this topic?\nAll related expenses will also be removed.";
  static final String dialogDeleteConfirm = "Delete";
  static final String dialogCancel = "Cancel";

  static final String errTopicName = "Please enter a suitable topic.";
  static final String errExpenseTitle = "Please enter a suitable title.";
  static final String errExpenseAmount = "Please enter a valid amount.";

  static final int maxAmountThreshold = 9999999999;
  static final int success = 1;
  static final int failure = -1;
  static final int wahr = 1;
  static final int falsch = 0;
  static final String defaultTopic = "General";
  static final int defaultTopicId = 1;
  static final String defaultCategory = CategoryModel.catOthers;
  static final int defaultCategoryId = 1;

  // Padding and Margin
  static final double stdMargin = 14;

  // App Fonts
  static final String fontBody = "Inter";
  static final String fontTitle = "Satoshi";

  // App Colors
  static final String primaryColor = "#0A6E5A";
  static final String secondaryColor = "#F4C430";
  static final String accentColor = "#FF6F61";
  static final String warmWhiteColor = "#FAF9F6";
  static final String darkBgColor = "#0F171E";
  static final String lightGrayColor = "#D1E3E0";
  static final String textPrimaryLightColor = "#1A1A1A";
  static final String textPrimaryDarkColor = "#F5F5F5";
  static final String textSecondaryColor = "#6B7280";
  static final String dividerColor = "#E5E7EB";
  static final String pureWhiteColor = "#FFFFFF";
  static final String pureBlackColor = "#000000";

}
