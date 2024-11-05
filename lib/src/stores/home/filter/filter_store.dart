import 'package:mobx/mobx.dart';
part 'filter_store.g.dart';

enum OrderBy { DATE, PRICE }

class FilterStore = _FilterStoreBase with _$FilterStore;

abstract class _FilterStoreBase with Store {
  //ordenando por data ou preco
  @observable
  OrderBy orderBy = OrderBy.DATE;
  @action
  void setOrderBy(OrderBy value) => orderBy = value;

  @observable
  int minPrice = 0;
  @observable
  int maxPrice = 10000;

  @action
  void setMinPrice(int value) => minPrice = value;

  @action
  void setMaxPrice(int value) => maxPrice = value;
}
