// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'Habit Wallet';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get currency => 'நாணயம்';

  @override
  String get selectCurrency => 'நாணயத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get theme => 'தீம்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String habitCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString பழக்கங்கள்',
      one: '1 பழக்கம்',
      zero: 'பழக்கங்கள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get tamil => 'தமிழ்';

  @override
  String transactionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பரிவர்த்தனைகள்',
      one: '1 பரிவர்த்தனை',
      zero: 'பரிவர்த்தனைகள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get transactions => 'பரிவர்த்தனைகள்';

  @override
  String get categories => 'வகைகள்';

  @override
  String get syncData => 'தரவை ஒத்திசை';

  @override
  String get analytics => 'பகுப்பாய்வு';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get welcomeBack => 'நல்வரவு';

  @override
  String get signInToManage => 'உங்கள் செல்வத்தை நிர்வகிக்க உள்நுழையவும்.';

  @override
  String get emailAddress => 'மின்னஞ்சல் முகவரி';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailRequired => 'மின்னஞ்சல் தேவை';

  @override
  String get invalidEmail => 'செல்லுபடியாகும் மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get securityPIN => 'பாதுகாப்பு பின்';

  @override
  String get pinHint => 'உங்கள் 4 இலக்க பின்னை உள்ளிடவும்';

  @override
  String get pinRequired => 'பின் தேவை';

  @override
  String get pinLengthError => 'பின் சரியாக 4 இலக்கங்களாக இருக்க வேண்டும்';

  @override
  String get rememberMe => 'இந்த சாதனத்தில் என்னை நினைவில் கொள்க';

  @override
  String get signIn => 'உள்நுழைக';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get profileUpdated => 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது!';

  @override
  String get save => 'சேமி';

  @override
  String get customizeExperience => 'உங்கள் அனுபவத்தைத் தனிப்பயனாக்குங்கள்';

  @override
  String get displayName => 'காட்சி பெயர்';

  @override
  String get nameHint => 'உங்கள் பெயரை உள்ளிடவும்';

  @override
  String get yearlySavingsGoal => 'ஆண்டு சேமிப்பு இலக்கு';

  @override
  String get savingsGoalDescription =>
      'உங்கள் வருடாந்திர சேமிப்பிற்கான இலக்கை நிர்ணயிக்கவும். மெனுவில் உங்கள் முன்னேற்றத்தைக் கண்காணிக்க நாங்கள் உதவுவோம்.';

  @override
  String get viewFinancialOverview => 'நிதி மேலோட்டத்தைப் பார்க்கவும்';

  @override
  String get addCategory => 'வகையைச் சேர்';

  @override
  String get newCategory => 'புதிய வகை';

  @override
  String get editCategory => 'வகையைத் திருத்து';

  @override
  String get deleteCategory => 'வகையை நீக்கு';

  @override
  String get deleteCategoryConfirmTitle => 'வகையை நீக்கவா?';

  @override
  String get deleteCategoryConfirmMessage => 'இது வகையை நிரந்தரமாக அகற்றும்.';

  @override
  String get categoryInUse => 'வகை பயன்பாட்டில் உள்ளது';

  @override
  String get hasTransactionsSuffix => 'ஏற்கனவே பரிவர்த்தனைகளைக் கொண்டுள்ளது.';

  @override
  String get optionMoveTransactions =>
      'விருப்பம் 1: பரிவர்த்தனைகளை நகர்த்தவும்';

  @override
  String get moveTransactionsDescription =>
      'இதை நீக்குவதற்கு முன் அனைத்து பரிவர்த்தனைகளையும் மற்றொரு வகைக்கு மாற்றவும்.';

  @override
  String get selectNewCategory => 'புதிய வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get moveAndDelete => 'நகர்த்தி நீக்கு';

  @override
  String get optionDeleteEverything => 'விருப்பம் 2: அனைத்தையும் நீக்கு';

  @override
  String get deleteEverythingDescription =>
      'இது இந்த வகையையும் அதனுடன் தொடர்புடைய அனைத்து பரிவர்த்தனைகளையும் நிரந்தரமாக நீக்கும். இந்தச் செயலைத் தவிர்க்க முடியாது.';

  @override
  String get deleteCategoryAndTransactions =>
      'வகை மற்றும் பரிவர்த்தனைகளை நீக்கு';

  @override
  String get areYouSure => 'நீங்கள் உறுதியாக இருக்கிறீர்களா?';

  @override
  String get allRecordsWillBeLost =>
      'இந்த வகையுடன் தொடர்புடைய அனைத்து பதிவுகளும் என்றென்றும் இழக்கப்படும்.';

  @override
  String get deleteAll => 'அனைத்தையும் நீக்கு';

  @override
  String get categoryName => 'வகையின் பெயர்';

  @override
  String get icon => 'ஐகான்';

  @override
  String get color => 'நிறம்';

  @override
  String get createCategory => 'வகையை உருவாக்கு';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get required => 'தேவை';

  @override
  String get noTransactionsAnalyze => 'பகுப்பாய்வு செய்ய பரிவர்த்தனைகள் இல்லை';

  @override
  String get financialOverview => 'நிதி மேலோட்டம்';

  @override
  String get incomeVsExpense => 'வருமானம் vs செலவு';

  @override
  String get daily => 'தினசரி';

  @override
  String get weekly => 'வாராந்திர';

  @override
  String get monthly => 'மாதாந்திர';

  @override
  String get yearly => 'ஆண்டு';

  @override
  String get today => 'இன்று';

  @override
  String get thisWeek => 'இந்த வாரம்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get thisYear => 'இந்த ஆண்டு';

  @override
  String get allTime => 'எல்லா நேரமும்';

  @override
  String get customRange => 'தனிப்பயன் வரம்பு';

  @override
  String get noDataAvailable => 'தரவு ஏதுமில்லை';

  @override
  String get income => 'வருமானம்';

  @override
  String get expense => 'செலவு';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get edited => 'திருத்தப்பட்டது';

  @override
  String get error => 'பிழை';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get tryAgain => 'மீண்டும் முயலவும்';

  @override
  String get version => 'பதிப்பு';

  @override
  String get backendUrl => 'பேக்கெண்ட் URL';

  @override
  String get configureBackendUrl => 'பேக்கெண்ட் URL ஐ உள்ளமைக்கவும்';

  @override
  String get dailyReminder => 'தினசரி நினைவூட்டல் (இரவு 8 மணி)';

  @override
  String get notifyTransactionsLogged =>
      'பரிவர்த்தனைகள் எதுவும் பதிவு செய்யப்படவில்லை என்றால் தெரிவிக்கவும்';

  @override
  String get general => 'பொது';

  @override
  String get network => 'பிணையம்';

  @override
  String get about => 'பற்றி';

  @override
  String get editTransaction => 'பரிவர்த்தனையைத் திருத்தவும்';

  @override
  String get newTransaction => 'புதிய பரிவர்த்தனை';

  @override
  String get amount => 'தொகை';

  @override
  String get category => 'வகை';

  @override
  String get date => 'தேதி';

  @override
  String get noteOptional => 'குறிப்பு (விருப்பமானது)';

  @override
  String get descriptionHint => 'விளக்கத்தைச் சேர்க்கவும்...';

  @override
  String get attachments => 'இணைப்புகள்';

  @override
  String get add => 'சேர்';

  @override
  String get addTransaction => 'பரிவர்த்தனையைச் சேர்';

  @override
  String get pleaseSelectCategory => 'தயவுசெய்து ஒரு வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get errorLoadingCategories => 'வகைகளை ஏற்றுவதில் பிழை';

  @override
  String get couldNotOpenFile => 'கோப்பைத் திறக்க முடியவில்லை';

  @override
  String get deleteTransaction => 'பரிவர்த்தனையை நீக்கு';

  @override
  String get deleteTransactionConfirmTitle => 'பரிவர்த்தனையை நீக்கவா?';

  @override
  String get deleteTransactionConfirmMessage =>
      'இந்தச் செயலை மாற்ற முடியாது. இந்தப் பரிவர்த்தனையை நீக்க விரும்புகிறீர்களா?';

  @override
  String get transactionDeleted => 'பரிவர்த்தனை நீக்கப்பட்டது';

  @override
  String get failedLoadCategories => 'வகைகளை ஏற்றுவதில் தோல்வி';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get savingsTarget => 'சேமிப்பு இலக்கு';

  @override
  String get surplus => 'உபரி';

  @override
  String get goal => 'இலக்கு';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get lightMode => 'ஒளி பயன்முறை';

  @override
  String get user => 'பயனர்';

  @override
  String get noTransactionsYet => 'இன்னும் பரிவர்த்தனைகள் இல்லை';

  @override
  String get startTrackingDescription =>
      'உங்கள் செலவுகளைக் கண்காணிக்கத் தொடங்குங்கள் மற்றும் உங்கள் பணம் எங்கு செல்கிறது என்பதைப் பாருங்கள்.';

  @override
  String get selectCategory => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get moneyFlow => 'பணப்புழக்கம்';

  @override
  String get scrollable => 'உருட்டக்கூடியது';

  @override
  String get whereYourMoneyGoes => 'உங்கள் பணம் எங்கே போகிறது';

  @override
  String get analyzingFinances => 'உங்கள் நிதியை பகுப்பாய்வு செய்கிறது...';

  @override
  String get couldNotLoadAnalytics => 'பகுப்பாய்வுகளை ஏற்ற முடியவில்லை';

  @override
  String get netSavings => 'நிகரச் சேமிப்பு';

  @override
  String get netDeficit => 'நிகரப் பற்றாக்குறை';

  @override
  String get totalSpent => 'மொத்த செலவு';

  @override
  String get net => 'நிகர';

  @override
  String savingsRateMsg(Object rate) {
    return 'நீங்கள் வருமானத்தில் $rate% சேமிக்கிறீர்கள்';
  }

  @override
  String get spendingExceedsIncome => 'செலவு வருமானத்தை மிஞ்சுகிறது';

  @override
  String get details => 'விவரங்கள்';

  @override
  String get status => 'நிலை';

  @override
  String get completed => 'முடிந்தது';

  @override
  String get time => 'நேரம்';

  @override
  String get note => 'குறிப்பு';

  @override
  String get transactionNotFound => 'பரிவர்த்தனை கிடைக்கவில்லை';

  @override
  String get movedOrDeleted =>
      'இது நீக்கப்பட்டிருக்கலாம் அல்லது மாற்றப்பட்டிருக்கலாம்.';

  @override
  String get goBack => 'பின் செல்';

  @override
  String get notificationTitle => 'தினசரி சரிபார்ப்பு 📝';

  @override
  String get notificationBody =>
      'இன்று உங்கள் வருமானம் அல்லது செலவுகளை பதிவு செய்ய மறக்காதீர்கள்!';
}
