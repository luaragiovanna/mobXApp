import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/repositories/user/favorite/favorite_repository.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'favorite_store.g.dart';

class FavoriteStore = _FavoriteStoreBase with _$FavoriteStore;

abstract class _FavoriteStoreBase with Store {
   _FavoriteStore() {
    reaction((_) => userManagerStore.isLoggedIn, (_) { //reacao -> qnd userManager store (descobre q tem usuario logado) realiza uma acao
    //acao get 
      _getFavoriteList(); 
    });
  }

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  ObservableList<Ad> favoriteList = ObservableList<Ad>(); //lista vazia de anuncios favoritados favoritou add na lista

  @action
  Future<void> _getFavoriteList() async {
    try {
      favoriteList.clear();
      final favorites =
          await FavoriteRepository().getFavorites(userManagerStore.user!);
      favoriteList.addAll(favorites); //precisa limpar toda vez pra n acumular
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> toggleFavorite(Ad ad) async {
    try {
      if (favoriteList.any((a) => a.id == ad.id)) {//chegar se ja n esta na lista
        favoriteList.removeWhere((a) => a.id == ad.id); //remove da lista
        await FavoriteRepository().delete(ad: ad, user: userManagerStore.user!);
      } else {//senao esta na lista
        favoriteList.add(ad); //apertou o botao adiciona na lista e manda pro repositorio
        await FavoriteRepository().save(ad: ad, user: userManagerStore.user!);
      }
    } catch (e) {
      print(e);
    }
  }
}
