import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/pages/signupapge/signup_page.dart';
import 'package:flutter_box_project/src/stores/login/login_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginPage extends StatelessWidget {
  LoginStore loginStore =
      LoginStore(email: '', password: '', loading: false, error: '');
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: sqrt1_2,
        title: const Text(
          'Entrar',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade200,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Observer(builder: (_) {
                      return loginStore.error != null
                          ? ErrorBox(
                              message: loginStore.error,
                            )
                          : SizedBox.shrink(); // Ou outro widget vazio
                    }),
                  ),
                  const Text('Entrar com e-mail',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.pink)),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !loginStore.loading,
                      decoration: InputDecoration(
                          labelText: 'Email', errorText: loginStore.emailError),
                      onChanged: loginStore.setEmail,
                    );
                  }),
                  const SizedBox(height: 15),
                  Observer(builder: (_) {
                    //sem observer n sabe quando o campo deve ser alterado
                    return TextField(
                      enabled: !loginStore.loading,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          errorText: loginStore.passwordError),
                      onChanged: loginStore.setPassword,
                    );
                  }),
                  const SizedBox(height: 16),
                  Observer(
                    builder: (_) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade200),
                        onPressed:
                            loginStore.loading ? null : loginStore.loginPressed,
                        // Desabilita o botão se loading for true
                        child: loginStore.loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ENTRAR',
                                style: TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                  Divider(),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text('Novo aqui? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SignUpPage()));
                        },
                        child: const Text('Cadastre-se',
                            style: TextStyle(
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
