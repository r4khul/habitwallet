// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Habit Wallet';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String habitCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString habits',
      one: '1 habit',
      zero: 'No habits',
    );
    return '$_temp0';
  }

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get tamil => 'Tamil';

  @override
  String transactionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String get transactions => 'Transactions';

  @override
  String get categories => 'Categories';

  @override
  String get syncData => 'Sync Data';

  @override
  String get analytics => 'Analytics';

  @override
  String get signOut => 'Sign Out';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToManage => 'Sign in to manage your wealth.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get securityPIN => 'Security PIN';

  @override
  String get pinHint => 'Enter your 4-digit PIN';

  @override
  String get pinRequired => 'PIN is required';

  @override
  String get pinLengthError => 'PIN must be exactly 4 digits';

  @override
  String get rememberMe => 'Remember me on this device';

  @override
  String get signIn => 'Sign In';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get save => 'Save';

  @override
  String get customizeExperience => 'Customize your experience';

  @override
  String get displayName => 'Display Name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get yearlySavingsGoal => 'Yearly Savings Goal';

  @override
  String get savingsGoalDescription =>
      'Set a target for your annual savings. We\'ll help you track your progress in the menu.';

  @override
  String get viewFinancialOverview => 'View Financial Overview';

  @override
  String get addCategory => 'Add Category';

  @override
  String get newCategory => 'New Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get deleteCategoryConfirmTitle => 'Delete Category?';

  @override
  String get deleteCategoryConfirmMessage =>
      'This will permanently remove the category.';

  @override
  String get categoryInUse => 'Category in Use';

  @override
  String get hasTransactionsSuffix => 'has existing transactions.';

  @override
  String get optionMoveTransactions => 'Option 1: Move Transactions';

  @override
  String get moveTransactionsDescription =>
      'Reassign all transactions to another category before deleting this one.';

  @override
  String get selectNewCategory => 'Select New Category';

  @override
  String get moveAndDelete => 'Move & Delete';

  @override
  String get optionDeleteEverything => 'Option 2: Delete Everything';

  @override
  String get deleteEverythingDescription =>
      'This will permanently delete this category AND all transactions associated with it. This action cannot be undone.';

  @override
  String get deleteCategoryAndTransactions => 'Delete Category & Transactions';

  @override
  String get areYouSure => 'Are you absolutely sure?';

  @override
  String get allRecordsWillBeLost =>
      'All records associated with this category will be lost forever.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get categoryName => 'Category Name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get createCategory => 'Create Category';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get required => 'Required';

  @override
  String get noTransactionsAnalyze => 'No transactions to analyze';

  @override
  String get financialOverview => 'Financial Overview';

  @override
  String get incomeVsExpense => 'Income vs Expense';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get allTime => 'All Time';

  @override
  String get customRange => 'Custom Range';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edited => 'EDITED';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get version => 'Version';

  @override
  String get backendUrl => 'Backend URL';

  @override
  String get configureBackendUrl => 'Configure Backend URL';

  @override
  String get dailyReminder => 'Daily Reminder (8 PM)';

  @override
  String get notifyTransactionsLogged => 'Notify if no transactions logged';

  @override
  String get general => 'General';

  @override
  String get network => 'Network';

  @override
  String get about => 'About';
}
