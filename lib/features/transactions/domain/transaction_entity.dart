import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';

/// Domain Entity: Represents a financial transaction.
///
/// **Business Rules & Invariants:**
/// 1. **Amount Sign**: The sign of [amount] determines its type:
///    - Positive (> 0) represents Income.
///    - Negative (< 0) represents Expense.
///    - Neutral (0) is valid but has no impact on balances.
/// 2. **Immutability**: Once created, the [id] and [timestamp] are authoritative
///    and must not change.
/// 3. **Sync State**: [editedLocally] reflects only the synchronization status
///    with remote sources and does not affect domain logic.
/// 4. **Unified Treatment**: All transactions (imported vs manual) are equal
///    citizens in the domain.
@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    /// Unique stable identifier. Invariant: Stable and immutable.
    required String id,

    /// Monetary amount. Sign determines income (+) vs expense (-).
    required double amount,

    /// The unique identifier of the associated category.
    required String categoryId,

    /// Authoritative timestamp of when the transaction occurred.
    required DateTime timestamp,

    /// Optional user-provided description or context.
    String? note,

    /// Internal flag representing local state vs remote persistence.
    @Default(false) bool editedLocally,
  }) = _TransactionEntity;

  const TransactionEntity._();

  /// Returns true if the transaction represents an inflow of funds.
  bool get isIncome => amount > 0;

  /// Returns true if the transaction represents an outflow of funds.
  bool get isExpense => amount < 0;

  /// Returns the absolute magnitude of the transaction regardless of sign.
  double get absoluteAmount => amount.abs();
}
