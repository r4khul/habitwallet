import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

@freezed
abstract class Currency with _$Currency {
  const factory Currency({
    required String code,
    required String symbol,
    required String name,
    required String flagEmoji,
  }) = _Currency;
}
