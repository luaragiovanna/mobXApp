// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/ad/ad_repository.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:flutter_box_project/src/models/user/user_model.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  _UserManagerStore() {
    _getCurrentUser();
  }

  @observable
  UserModel user = UserModel(
      name: '', email: '', phone: '', id: '', createdAt: DateTime.now());

  @action
  void setUser(UserModel value) => user = value;

  @computed
  bool get isLoggedIn => user != null;

  Future<void> _getCurrentUser() async {
    final user = await UserRepository().currentUser();
    setUser(user);
  }

  Future<void> logout() async {
    await UserRepository().logout();
    // setUser(null);
  }

  // Exemplo de como criar um anúncio
  Future<void> createNewAd(String title, String description,
      CategoryModel category, num price, bool hidePhone, List images) async {
    final userManagerStore = GetIt.I<UserManagerStore>();

    if (userManagerStore.user == null) {
      // Caso não haja usuário logado
      throw Exception("Usuário não está logado.");
    }

    final user = userManagerStore.user!; // Pega o usuário logado

    // Criação do anúncio
    final newAd = Ad(
      user: user, // Passa o usuário logado
      images: ObservableList.of(
          images), // Supondo que 'images' seja uma lista de imagens
      id: '', // O ID será gerado pelo Parse
      title: title,
      description: description,
      category: category,
      price: price,
      createdDate: DateTime.now(), // Data de criação do anúncio
      hidePhone: hidePhone,
      views: 0,
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
