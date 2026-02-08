// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrencyController)
final currencyControllerProvider = CurrencyControllerProvider._();

final class CurrencyControllerProvider
    extends $AsyncNotifierProvider<CurrencyController, Currency> {
  CurrencyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyControllerHash();

  @$internal
  @override
  CurrencyController create() => CurrencyController();
}

String _$currencyControllerHash() =>
    r'01d77996a702c4b5a507bc6ab154dfe939a2eb27';

abstract class _$CurrencyController extends $AsyncNotifier<Currency> {
  FutureOr<Currency> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Currency>, Currency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Currency>, Currency>,
              AsyncValue<Currency>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currencySymbol)
final currencySymbolProvider = CurrencySymbolProvider._();

final class CurrencySymbolProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  CurrencySymbolProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencySymbolProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencySymbolHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currencySymbol(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currencySymbolHash() => r'cbafd15921efd62bedabcb93d6e8e6b32a4e7f9b';
