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
}
