import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';

/// Domain Entity: Represents a financial transaction.
/// Boundary Rules: Pure Dart only, immutable, domain-specific logic.
@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required String category,
    required DateTime timestamp,
    String? note,
    @Default(false) bool editedLocally,
  }) = _TransactionEntity;

  const TransactionEntity._();

  /// Returns true if the transaction is an income (amount > 0).
  bool get isIncome => amount > 0;

  /// Returns true if the transaction is an expense (amount < 0).
  bool get isExpense => amount < 0;
}
