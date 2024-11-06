import 'package:flutter/foundation.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/category/category_repository.dart';
import 'package:flutter_box_project/src/stores/connectivity/connectivity_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'category_store.g.dart';

class CategoryStore = _CategoryStoreBase with _$CategoryStore;

abstract class _CategoryStoreBase with Store {
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _CategoryStore() {
    autorun((_) {
      if (connectivityStore.connected && categoryList.isEmpty)
        _loadCategories();
    });
  }

  ObservableList<CategoryModel> categoryList = ObservableList<CategoryModel>();

  @computed
  List<CategoryModel> get allCategoryList => List.from(categoryList)
    ..insert(0, CategoryModel(id: '*', description: 'Todas', name: ''));

  @action
  void setCategories(List<CategoryModel> categories) {
    categoryList.clear();
    categoryList.addAll(categories);
  }

  @observable
  String error = '';

  @action
  void setError(String value) => error = value;

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryRepository().getList();
      setCategories(categories.cast<CategoryModel>());
    } catch (e) {
      setError(e.toString());
    }
  }
}
