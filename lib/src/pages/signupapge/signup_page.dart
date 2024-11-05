import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/pages/signupapge/components/field_title.dart';
import 'package:flutter_box_project/src/stores/signup/signup_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SignUpPage extends StatelessWidget {
  final SignupStore signupStore = SignupStore(
      name: '',
      email: '',
      phone: '',
      pass1: '',
      pass2: '',
      loading: false,
      error: '');

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FildeTitle(title: 'Apelido', subtitle: ''),
                  Observer(
                    builder: (_) {
                      return TextField(
                        enabled: !signupStore.loading,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 247, 133, 228),
                          )),
                          hintText: 'John Doe',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(109, 140, 97, 133),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          errorText: signupStore.nameError,
                        ),
                        onChanged: signupStore.setName,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FildeTitle(title: 'E-mail', subtitle: ''),
                  Observer(
                    builder: (_) {
                      return TextField(
                        enabled: !signupStore.loading,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 247, 133, 228),
                          )),
                          hintText: 'johndoe@gmail.com',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(109, 140, 97, 133),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          errorText: signupStore.emailError,
                        ),
                        onChanged: signupStore.setEmail,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FildeTitle(title: 'Celular', subtitle: ' '),
                  Observer(
                    builder: (_) {
                      return TextField(
                        enabled: !signupStore.loading,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 247, 133, 228),
                          )),
                          hintText: '55 42 998564321',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(109, 140, 97, 133),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          errorText: signupStore.phoneError,
                        ),
                        onChanged: signupStore.setPhone,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FildeTitle(title: 'Senha', subtitle: ''),
                  Observer(
                    builder: (_) {
                      return TextField(
                        obscureText: true,
                        enabled: !signupStore.loading,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 247, 133, 228),
                          )),
                          hintText: 'Insira sua senha aqui...',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(109, 140, 97, 133),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          errorText: signupStore.pass1Error,
                        ),
                        onChanged: signupStore.setPass1,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FildeTitle(title: 'Confirmar senha', subtitle: ''),
                  Observer(
                    builder: (_) {
                      return TextField(
                        obscureText: true,
                        enabled: !signupStore.loading,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 247, 133, 228),
                          )),
                          hintText: 'Repita sua senha',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(109, 140, 97, 133),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          errorText: signupStore.pass2Error,
                        ),
                        onChanged: signupStore.setPass2,
                      );
                    },
                  ),
                  Observer(builder: (_) {
                    return Container(
                      height: 40,
                      margin: EdgeInsets.only(
                        top: 20,
                        bottom: 22,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade300,
                        ),
                        onPressed: signupStore.signUpPressed,
                        child: signupStore.loading
                            ? CircularProgressIndicator(
                                color: Colors.pink,
                              )
                            : Text(
                                'Cadastrar',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  }),
                  Divider(
                    color: Colors.pink.shade100,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Observer(builder: (_) {
                      return ErrorBox(
                        message: signupStore.error,
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: TextStyle(
                              color: Colors.pink.shade300, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            ' Entrar',
                            style: TextStyle(
                                color: Colors.pink,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green),
                          ),
                        )
                      ],
                    ),
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
