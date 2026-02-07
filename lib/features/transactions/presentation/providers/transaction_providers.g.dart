// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State Provider for the list of all transactions.
/// Responsibility: Observes the TransactionRepository and exposes the current transaction state.

@ProviderFor(transactions)
final transactionsProvider = TransactionsProvider._();

/// State Provider for the list of all transactions.
/// Responsibility: Observes the TransactionRepository and exposes the current transaction state.

final class TransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionEntity>>,
          List<TransactionEntity>,
          FutureOr<List<TransactionEntity>>
        >
    with
        $FutureModifier<List<TransactionEntity>>,
        $FutureProvider<List<TransactionEntity>> {
  /// State Provider for the list of all transactions.
  /// Responsibility: Observes the TransactionRepository and exposes the current transaction state.
  TransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransactionEntity>> create(Ref ref) {
    return transactions(ref);
  }
}

String _$transactionsHash() => r'6e075317a41253cd9e21040519e0f61db8e8b976';

/// State Provider for a specific transaction by its ID.

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

/// State Provider for a specific transaction by its ID.

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransactionEntity?>,
          TransactionEntity?,
          FutureOr<TransactionEntity?>
        >
    with
        $FutureModifier<TransactionEntity?>,
        $FutureProvider<TransactionEntity?> {
  /// State Provider for a specific transaction by its ID.
  TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TransactionEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TransactionEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'0bfa7374a3961efb7b94fa30b48ed52573fcb3f0';

/// State Provider for a specific transaction by its ID.

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TransactionEntity?>, String> {
  TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State Provider for a specific transaction by its ID.

  TransactionByIdProvider call(String id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}
