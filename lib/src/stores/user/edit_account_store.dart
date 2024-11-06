import 'dart:ui';

import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'edit_account_store.g.dart';

class EditAccountStore = _EditAccountStoreBase with _$EditAccountStore;

abstract class _EditAccountStoreBase with Store {
  _EditAccountStore() {
    user = userManagerStore.user!;

    ///setando valores antigos

    userType = user.userType;
    name = user.name;
    phone = user.phone;
  }

  late UserModel user;

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  @observable
  late UserType userType;

  @action
  void setUserType(int value) => userType = UserType.values[value];

  @observable
  String name = '';

  @action
  void setName(String value) => name = value;

  @computed
  bool get nameValid => name != null && name.length >= 6;
  String get nameError =>
      nameValid || name.isNotEmpty ? '' : 'Campo obrigatório';

  @observable
  String phone = '';

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone != null && phone.length >= 14;
  String get phoneError =>
      phoneValid || phone.isNotEmpty ? '' : 'Campo obrigatório';

  @observable
  String pass1 = '';

  @action
  void setPass1(String value) => pass1 = value;

  @observable
  String pass2 = '';

  @action
  void setPass2(String value) => pass2 = value;

  @computed
  bool get passValid => pass1 == pass2 && (pass1.length >= 6 || pass1.isEmpty);
  String get passError {
    if (pass1.isNotEmpty && pass1.length < 6)
      return 'Senha muito curta';
    else if (pass1 != pass2) return 'Senhas não coincidem';
    return '';
  }

  @computed
  bool get isFormValid => nameValid && phoneValid && passValid;

  @observable
  bool loading = false;

  @computed
  VoidCallback? get savePressed => (isFormValid && !loading)
      ? _save
      : null; //se formulario é valido retorna funcao save ou desabilita botao
  //enq estiver carregando desabilita botao
  @action
  Future<void> _save() async {
    //carregando. . .
    loading = true;
    //salvar dados do usuario //objeto user
    //salva atributos atualizados
    user.name = name;
    user.phone = phone;
    user.userType = userType;

    if (pass1.isNotEmpty) {
      //se alterou a senha
      user.password = pass1;
    } else {
      user.password; //n alterou a senha guardar em uma varaivel a senha atual
    }

    try {
      await UserRepository().save(user);
      userManagerStore.setUser(user);
    } catch (e) {
      print(e);
    }

    loading = false;
  }

  void logout() => userManagerStore.logout();
}
