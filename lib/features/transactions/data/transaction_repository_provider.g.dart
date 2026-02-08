// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionRemoteDataSource)
final transactionRemoteDataSourceProvider =
    TransactionRemoteDataSourceProvider._();

final class TransactionRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          TransactionRemoteDataSource,
          TransactionRemoteDataSource,
          TransactionRemoteDataSource
        >
    with $Provider<TransactionRemoteDataSource> {
  TransactionRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TransactionRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRemoteDataSource create(Ref ref) {
    return transactionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRemoteDataSource>(value),
    );
  }
}

String _$transactionRemoteDataSourceHash() =>
    r'3b199254b2b253286b9efa089f5581b71f78eacb';

/// Provider for the TransactionRepository interface.
/// Dependency: Injects TransactionDao and RemoteDataSource into the implementation.

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

/// Provider for the TransactionRepository interface.
/// Dependency: Injects TransactionDao and RemoteDataSource into the implementation.

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepository,
          TransactionRepository,
          TransactionRepository
        >
    with $Provider<TransactionRepository> {
  /// Provider for the TransactionRepository interface.
  /// Dependency: Injects TransactionDao and RemoteDataSource into the implementation.
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepository create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepository>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'79ec493d0466c12f7f18061ce700f8d8c75fcd3c';
