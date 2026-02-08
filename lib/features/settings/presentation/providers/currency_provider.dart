import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/currency.dart';

part 'currency_provider.g.dart';

@riverpod
class CurrencyController extends _$CurrencyController {
  static const _storageKey = 'selected_currency_code';

  static const List<Currency> availableCurrencies = [
    Currency(
      code: 'USD',
      symbol: '\$',
      name: 'United States Dollar',
      flagEmoji: '🇺🇸',
    ),
    Currency(code: 'EUR', symbol: '€', name: 'Euro', flagEmoji: '🇪🇺'),
    Currency(
      code: 'GBP',
      symbol: '£',
      name: 'British Pound',
      flagEmoji: '🇬🇧',
    ),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', flagEmoji: '🇮🇳'),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', flagEmoji: '🇯🇵'),
    Currency(
      code: 'AUD',
      symbol: 'A\$',
      name: 'Australian Dollar',
      flagEmoji: '🇦🇺',
    ),
    Currency(
      code: 'CAD',
      symbol: 'C\$',
      name: 'Canadian Dollar',
      flagEmoji: '🇨🇦',
    ),
    Currency(code: 'CHF', symbol: 'Fr', name: 'Swiss Franc', flagEmoji: '🇨🇭'),
    Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', flagEmoji: '🇨🇳'),
    Currency(
      code: 'KRW',
      symbol: '₩',
      name: 'South Korean Won',
      flagEmoji: '🇰🇷',
    ),
    Currency(
      code: 'BRL',
      symbol: 'R\$',
      name: 'Brazilian Real',
      flagEmoji: '🇧🇷',
    ),
    Currency(
      code: 'RUB',
      symbol: '₽',
      name: 'Russian Ruble',
      flagEmoji: '🇷🇺',
    ),
    Currency(
      code: 'ZAR',
      symbol: 'R',
      name: 'South African Rand',
      flagEmoji: '🇿🇦',
    ),
    Currency(
      code: 'MXN',
      symbol: '\$',
      name: 'Mexican Peso',
      flagEmoji: '🇲🇽',
    ),
    Currency(
      code: 'SGD',
      symbol: 'S\$',
      name: 'Singapore Dollar',
      flagEmoji: '🇸🇬',
    ),
    Currency(
      code: 'HKD',
      symbol: 'HK\$',
      name: 'Hong Kong Dollar',
      flagEmoji: '🇭🇰',
    ),
    Currency(
      code: 'NZD',
      symbol: 'NZ\$',
      name: 'New Zealand Dollar',
      flagEmoji: '🇳🇿',
    ),
  ];

  static const _defaultCurrency = Currency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    flagEmoji: '🇮🇳',
  );

  @override
  FutureOr<Currency> build() async {
    const storage = FlutterSecureStorage();
    final code = await storage.read(key: _storageKey);
    if (code == null) return _defaultCurrency;

    return availableCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => _defaultCurrency,
    );
  }

  Future<void> selectCurrency(Currency currency) async {
    const storage = FlutterSecureStorage();
    // Optimistic update
    state = AsyncValue.data(currency);
    await storage.write(key: _storageKey, value: currency.code);
  }
}

@riverpod
String currencySymbol(Ref ref) {
  return ref
      .watch(currencyControllerProvider)
      .maybeWhen(
        data: (c) => c.symbol,
        orElse: () => '₹', // Matches default
      );
}
