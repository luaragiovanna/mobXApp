import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/repositories/ad/ad_repository.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'my_ads_store.g.dart';

class MyAdsStore = _MyAdsStoreBase with _$MyAdsStore;

abstract class _MyAdsStoreBase with Store {
  _MyAdsStore() {
    _getMyAds();
  }

  @observable
  List<Ad> allAds = [];

  @computed
  List<Ad> get activeAds =>
      allAds.where((ad) => ad.status == AdStatus.ACTIVE).toList();
  List<Ad> get pendingAds =>
      allAds.where((ad) => ad.status == AdStatus.PENDING).toList();
  List<Ad> get soldAds =>
      allAds.where((ad) => ad.status == AdStatus.SOLD).toList();

  Future<void> _getMyAds() async {
    final user = GetIt.I<UserManagerStore>().user;

    try {
      loading = true; //inicializo a busca
      allAds = await AdRepository().getMyAds(user!);
      loading = false; //finalizo
    } catch (e) {}
  }

  @observable
  bool loading = false; 

  void refresh() => _getMyAds(); //atualiza tela com anuncios mais recentes

  @action
  Future<void> soldAd(Ad ad) async { //recebe anuncio
    loading = true; //carrega
    await AdRepository().sold(ad);//espera repositorio marcar como vendido
    refresh();//refresh na tela
  }

  @action
  Future<void> deleteAd(Ad ad) async {
    loading = true;
    await AdRepository().delete(ad);
    refresh();
  }

}
