// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Feature State: Manages the collection of transactions.
/// Responsibility: Provides an observable list of transactions and handles mutative actions.
/// Ownership: Owns the transaction logic; calls repository only.

@ProviderFor(TransactionController)
final transactionControllerProvider = TransactionControllerProvider._();

/// Feature State: Manages the collection of transactions.
/// Responsibility: Provides an observable list of transactions and handles mutative actions.
/// Ownership: Owns the transaction logic; calls repository only.
final class TransactionControllerProvider
    extends
        $AsyncNotifierProvider<TransactionController, List<TransactionEntity>> {
  /// Feature State: Manages the collection of transactions.
  /// Responsibility: Provides an observable list of transactions and handles mutative actions.
  /// Ownership: Owns the transaction logic; calls repository only.
  TransactionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionControllerHash();

  @$internal
  @override
  TransactionController create() => TransactionController();
}

String _$transactionControllerHash() =>
    r'c034808cfdb265ba861d90b2298b4a5d9d8ed94a';

/// Feature State: Manages the collection of transactions.
/// Responsibility: Provides an observable list of transactions and handles mutative actions.
/// Ownership: Owns the transaction logic; calls repository only.

abstract class _$TransactionController
    extends $AsyncNotifier<List<TransactionEntity>> {
  FutureOr<List<TransactionEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<TransactionEntity>>,
              List<TransactionEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<TransactionEntity>>,
                List<TransactionEntity>
              >,
              AsyncValue<List<TransactionEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Feature State: Exposes a single transaction by its ID.

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

/// Feature State: Exposes a single transaction by its ID.

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
  /// Feature State: Exposes a single transaction by its ID.
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

/// Feature State: Exposes a single transaction by its ID.

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

  /// Feature State: Exposes a single transaction by its ID.

  TransactionByIdProvider call(String id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}
