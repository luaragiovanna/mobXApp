// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:flutter_box_project/src/helpers/extensions.dart';
import 'package:flutter_box_project/src/stores/signup/signup_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String email;

  @observable
  String password;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null && email.isEmailValid();
  String get emailError {
    if (email == null || emailValid)
      return '';
    else if (email.isEmpty)
      return 'Campo obrigatório';
    else
      return 'E-mail inválido';
  }

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password.length >= 4;

  String get passwordError => passwordValid ? '' : 'Senha inválida';

  @computed
  void Function() get loginPressed =>
      emailValid && passwordValid && !loading ? _login : () {};

  @observable
  bool loading = false;

  @observable
  String error;
  _LoginStore({
    required this.email,
    required this.password,
    required this.loading,
    required this.error,
  });

  @action
  Future<void> _login() async {
    print('Login started');
    loading = true;
    try {
      final user = await UserRepository().loginWithEmail(email, password);
      GetIt.I<UserManagerStore>()
          .setUser(user); //salvou usuario q fez o login dentro do managerstore
    } catch (e) {
      error = e.toString();
    }
    print('Login finished');
    loading = false;
  }
}
