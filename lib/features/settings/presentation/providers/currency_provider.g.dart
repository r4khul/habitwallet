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
