class AppLanguage {
  const AppLanguage({
    required this.name,
    required this.nativeName,
    required this.languageCode,
    required this.flagEmoji,
  });

  final String name;
  final String nativeName;
  final String languageCode;
  final String flagEmoji;

  static const List<AppLanguage> availableLanguages = [
    AppLanguage(
      name: 'English',
      nativeName: 'English',
      languageCode: 'en',
      flagEmoji: '🇺🇸',
    ),
    AppLanguage(
      name: 'Tamil',
      nativeName: 'தமிழ்',
      languageCode: 'ta',
      flagEmoji: '🇮🇳',
    ),
  ];
}
