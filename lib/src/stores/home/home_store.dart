import 'package:flutter_box_project/src/models/ad/ad.dart' as ad_model;
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/ad/ad_repository.dart';
import 'package:flutter_box_project/src/stores/connectivity/connectivity_store.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../models/ad/ad.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  final ConnectivityStore connectivityStore = GetIt.I<
      ConnectivityStore>(); //qualquer mudançaa no estado de conexao chama o autorun

  _HomeStore() {
    autorun((_) async {
      connectivityStore.connected;
      try {
        setLoading(true);
        final newAds = await AdRepository().getHomeAdList(
          filter: filter,
          search: search,
          category: category,
          page: page,
        );
        addNewAds(newAds);
        setError('');
        setLoading(false);
      } catch (e) {
        setError(e.toString());
      }
    });
  }

  ObservableList<ad_model.Ad> adList = ObservableList<ad_model.Ad>();

  @observable
  String search = '';

  @action
  void setSearch(String value) {
    search = value;
    resetPage();
  }

  @observable
  CategoryModel category = CategoryModel(id: '', description: '', name: '');

  @action
  void setCategory(CategoryModel value) {
    category = value;
    resetPage();
  }

  @observable
  FilterStore filter = FilterStore();

  FilterStore get clonedFilter => filter.clone();

  @action
  void setFilter(FilterStore value) {
    filter = value;
    resetPage();
  }

  @observable
  String error = '';

  @action
  void setError(String value) => error = value;

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @observable
  int page = 0;

  @observable
  bool lastPage = false;

  @action
  void loadNextPage() {
    page++;
  }

  @action
  void addNewAds(List<ad_model.Ad> newAds) {
    if (newAds.length < 10) lastPage = true;
    adList.addAll(newAds);
  }

  @computed
  int get itemCount => lastPage ? adList.length : adList.length + 1;

  void resetPage() {
    page = 0;
    adList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && adList.isEmpty;
}
