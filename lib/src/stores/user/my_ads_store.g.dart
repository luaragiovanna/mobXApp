// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_ads_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyAdsStore on _MyAdsStoreBase, Store {
  Computed<List<Ad>>? _$activeAdsComputed;

  @override
  List<Ad> get activeAds =>
      (_$activeAdsComputed ??= Computed<List<Ad>>(() => super.activeAds,
              name: '_MyAdsStoreBase.activeAds'))
          .value;

  late final _$allAdsAtom =
      Atom(name: '_MyAdsStoreBase.allAds', context: context);

  @override
  List<Ad> get allAds {
    _$allAdsAtom.reportRead();
    return super.allAds;
  }

  @override
  set allAds(List<Ad> value) {
    _$allAdsAtom.reportWrite(value, super.allAds, () {
      super.allAds = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_MyAdsStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$soldAdAsyncAction =
      AsyncAction('_MyAdsStoreBase.soldAd', context: context);

  @override
  Future<void> soldAd(Ad ad) {
    return _$soldAdAsyncAction.run(() => super.soldAd(ad));
  }

  late final _$deleteAdAsyncAction =
      AsyncAction('_MyAdsStoreBase.deleteAd', context: context);

  @override
  Future<void> deleteAd(Ad ad) {
    return _$deleteAdAsyncAction.run(() => super.deleteAd(ad));
  }

  @override
  String toString() {
    return '''
allAds: ${allAds},
loading: ${loading},
activeAds: ${activeAds}
    ''';
  }
}
