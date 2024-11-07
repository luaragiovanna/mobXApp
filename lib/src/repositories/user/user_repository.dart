import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserRepository {
  Future<UserModel?> signUp(UserModel user) async {
    final parseUser = ParseUser(user.email, user.password, null);

    parseUser.set<String>(keyUserName, user.name);
    parseUser.set<String>(keyUserPhone, user.phone);
    parseUser.set<String>(keyUserEmail, user.email);
    parseUser.set<String>(keyUserType, user.userType.index.toString());

    final response = await parseUser.signUp();
    if (response.success) {
      // Aqui, certifique-se de que você está lidando com uma lista.
      if (response.results != null && response.results!.isNotEmpty) {
        return mapParseToUser(response.results!.first as ParseUser);
      } else {
        throw Exception('Usuário não encontrado após o registro.');
      }
    } else {
      throw ParseErrors.getDescription(response.error!.code);
    }
  }

  UserModel mapParseToUser(ParseUser parseUser) {
    return UserModel(
      id: parseUser.get(keyUserId),
      name: parseUser.get(keyUserName),
      email: parseUser.get(keyUserEmail),
      phone: parseUser.get(keyUserPhone),
      userType: UserType.values[int.parse(parseUser.get(keyUserType))],
      createdAt: parseUser.get(keyUserCreatedAt),
      password: '',
    );
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code));
    }
  }

  Future<UserModel?> currentUser() async {
    final parseUser = await ParseUser.currentUser();
    if (parseUser == null) {
      throw Exception('Usuário não logado.');
    }

    final response =
        await ParseUser.getCurrentUserFromServer(parseUser.sessionToken);
    if (response == null || !response.success) {
      print('Erro ao obter usuário: ${response?.error?.message}');
      await parseUser.logout();
      throw Exception('Erro ao obter usuário.');
    }

    return mapParseToUser(response.result);
  }

  Future<void> save(UserModel user) async {
    //obter objeto parse user logado atualmente
    final ParseUser parseUser = await ParseUser.currentUser();

    if (parseUser != null) {
      //setar nome de usuario com dados atualizados
      parseUser.set<String>(keyUserName, user.name);
      parseUser.set<String>(keyUserPhone, user.phone);
      parseUser.set<int>(keyUserType, user.userType.index);

      if (user.password != null) {
        parseUser.password = user.password;
      }

      final response = await parseUser.save();

      if (!response.success) //se n deu certo retornar erro
        return Future.error(ParseErrors.getDescription(response.error!.code));

      if (user.password != null) {
        //trocou a senha
        await parseUser.logout();

        final loginResponse =
            await ParseUser(user.email, user.password, user.email).login();

        if (!loginResponse.success)
          return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    }
  }

  Future<void> logout() async {
    final ParseUser currentUser = await ParseUser.currentUser();
    await currentUser.logout();
  }
}
