import 'package:flutter/foundation.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:mobx/mobx.dart';
part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  String search = '';

  @action
  void setSearch(String value) {
    if (value.isNotEmpty) {
      search = value;
    } else {
      search = '';
    }
  }

  @observable
  CategoryModel? category;

  @action
  void setCategory(CategoryModel value) => category = value;
}
