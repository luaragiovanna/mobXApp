// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_box_project/src/helpers/extensions.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'signup_store.g.dart';

class SignupStore = _SignupStore with _$SignupStore;

abstract class _SignupStore with Store {
  @observable
  String name;

  @action
  void setName(String value) => name = value;

  @computed
  bool get nameValid => name != null && name.length > 6;
  String get nameError {
    if (name == null || nameValid) {
      return '';
    } else if (name.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return 'Campo obrigatório';
    else
      // ignore: curly_braces_in_flow_control_structures
      return 'Nome muito curto';
  }

  @observable
  String email;

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

  @observable
  String phone;

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone != null && phone.length >= 9;
  String get phoneError {
    if (phone == null || phoneValid)
      return '';
    else if (phone.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Celular inválido';
  }

  @observable
  String pass1;

  @action
  void setPass1(String value) => pass1 = value;

  @computed
  bool get pass1Valid => pass1 != null && pass1.length >= 6;
  String get pass1Error {
    if (pass1 == null || pass1Valid)
      return '';
    else if (pass1.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Senha muito curta';
  }

  @observable
  String pass2;

  @action
  void setPass2(String value) => pass2 = value;

  @computed
  bool get pass2Valid => pass2 != null && pass2 == pass1;
  String get pass2Error {
    if (pass2 == null || pass2Valid)
      return '';
    else
      return 'Senhas não coincidem';
  }

  @computed
  bool get isFormValid =>
      nameValid && emailValid && phoneValid && pass1Valid && pass2Valid;

  @computed
  dynamic get signUpPressed => (isFormValid && !loading) ? _signUp : null;

  @observable
  bool loading = false;

  @observable
  String error = '';

  @action
  setError(String value) => error = value;

  _SignupStore({
    required this.name,
    required this.email,
    required this.phone,
    required this.pass1,
    required this.pass2,
    required this.loading,
    required this.error,
  });

  @action
  Future<void> _signUp() async {
    loading = true;

    final user = UserModel(
      name: name,
      email: email,
      phone: phone,
      password: pass1,
      id: '',
      createdAt: DateTime.now(),
    );
    //passar info do usuario por meio UserModel e colocar dentro do signUp
    //pegar os eerros e mostrar pro usuario
    try {
      final resultUser = await UserRepository().signUp(user);
      GetIt.I<UserManagerStore>().setUser(resultUser);
      print(resultUser);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
