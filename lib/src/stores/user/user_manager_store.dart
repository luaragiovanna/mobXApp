import 'package:flutter_box_project/src/models/ad/ad.dart' as ad_model;
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/ad/ad_repository.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  _UserManagerStore() {
    _getCurrentUser();
  }

  @observable
  UserModel? user;

  @action
  void setUser(UserModel? value) => user = value;

  @computed
  bool get isLoggedIn => user != null;

  Future<void> _getCurrentUser() async {
    final currentUser = await UserRepository().currentUser();
    if (currentUser != null) {
      setUser(currentUser);
    } else {
      setUser(null); // Define user como null se não houver usuário logado
    }
  }

  Future<void> logout() async {
    await UserRepository().logout();
    setUser(null); // Garante que o usuário é definido como null após logout
  }

  // Exemplo de como criar um anúncio
  Future<void> createNewAd(
    String title,
    String description,
    CategoryModel category,
    num price,
    bool hidePhone,
    List images,
  ) async {
    if (user == null) {
      // Caso não haja usuário logado
      throw Exception("Usuário não está logado.");
    }

    // Criação do anúncio
    final newAd = ad_model.Ad(
      user: user!,
      images: ObservableList.of(images),
      title: title,
      description: description,
      category: category,
      price: price,
      hidePhone: hidePhone,
      views: 0,
      createdAt: DateTime.now(),
    );

    // Salva o anúncio no banco de dados (Parse)
    try {
      await AdRepository().save(newAd);
      print("Anúncio criado com sucesso!");
    } catch (e) {
      print("Erro ao criar o anúncio: $e");
    }
  }
}
