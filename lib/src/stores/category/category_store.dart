import 'package:flutter/foundation.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/category/category_repository.dart';
import 'package:mobx/mobx.dart';
part 'category_store.g.dart';

class CategoryStore = _CategoryStoreBase with _$CategoryStore;

abstract class _CategoryStoreBase with Store {
  ObservableList<CategoryModel> categoryList = ObservableList<
      CategoryModel>(); //  modificando observableList tem q  settar por meio de action

  //
  _CategoryStoreBase() {
    _loadCategories();
  }
  @observable
  String? error;

  @action
  void setError(String value) => error = value;

  @action
  void setCategories(List<CategoryModel> categories) {
    categoryList.clear();
    categoryList.addAll(categories);
  }

  Future<void> _loadCategories() async {
    try {
      //acessar repo e salvar categorias aq
      final categories = await CategoryRepository().getList();
      //setar lista de categorias
      setCategories(categories);
    } catch (e) {
      setError(e.toString());
    }
  }

  @computed
  List<CategoryModel> get allCategoryList => List.from(categoryList)
    ..insert(0, CategoryModel(id: '*', description: 'Todas'));
}
