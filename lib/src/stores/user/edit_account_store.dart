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

    /// Setando valores antigos
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
  bool get nameValid => name.isNotEmpty && name.length >= 6;
  String get nameError => nameValid ? '' : 'Campo obrigatório';

  @observable
  String phone = '';

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone.isNotEmpty && phone.length >= 14;
  String get phoneError => phoneValid ? '' : 'Campo obrigatório';

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
    if (pass1.isNotEmpty && pass1.length < 6) return 'Senha muito curta';
    if (pass1 != pass2) return 'Senhas não coincidem';
    return '';
  }

  @computed
  bool get isFormValid => nameValid && phoneValid && passValid;

  @observable
  bool loading = false;

  @computed
  VoidCallback? get savePressed => (isFormValid && !loading) ? _save : null;

  @action
  Future<void> _save() async {
    loading = true;

    // Crie uma nova instância de UserModel com os dados atualizados
    final updatedUser = UserModel(
      id: user.id,
      name: name,
      email: user.email,
      phone: phone,
      password: pass1.isNotEmpty ? pass1 : user.password,
      userType: userType,
      createdAt: user.createdAt,
    );

    try {
      await UserRepository().save(updatedUser);
      userManagerStore.setUser(updatedUser);
    } catch (e) {
      print(e);
    }

    loading = false;
  }

  void logout() => userManagerStore.logout();
}
