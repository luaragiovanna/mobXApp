// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:mobx/mobx.dart';

import 'package:flutter_box_project/src/models/user/user_model.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  @observable
  UserModel? userModel;
  _UserManagerStore() {
    getCurrentUser();
  }
  @action
  void setUser(UserModel value) => userModel = value;

  @computed
  // ignore: unnecessary_null_comparison
  bool get isLoggedIn => userModel != null; //usuario logado

  Future<void> getCurrentUser() async {
    final user = await UserRepository().currentUser();
    setUser(user);
  } //funcao interna
}
