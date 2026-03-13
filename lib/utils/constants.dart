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
  static final String currencyOnlyList = "/currency-only-list";
  static final String languageOnlyList = "/language-only-list";

  // App Images
  static final String imgLogo = "assets/images/kashew_logo.png";

  // Settings key-value pair
  static final String settingsCurrency = "currency";
  static final String settingsLanguage = "language";

  static final String langEng = "en";
  static final String langDe = "de";
  static final String langEs = "es";

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
