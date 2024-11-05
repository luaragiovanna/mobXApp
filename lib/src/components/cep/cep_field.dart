import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/stores/cep/cep_store.dart';
import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CepField extends StatelessWidget {
  final CreateStore createStore;
  final CepStore cepStore =
      CepStore(cep: '', error: '', address: null, loading: false);
  CepField(this.createStore, {super.key}) ; //ja cria com cep inicial

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         Observer(builder: (_){
          return  TextFormField(
            onChanged: cepStore.setCep,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            decoration:  InputDecoration(
              errorText:  createStore.addressError,
              labelText: 'CEP',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18),
              contentPadding: EdgeInsets.fromLTRB(16, 10, 12, 10),
            ),
          );
         }),
          Observer(builder: (_) {
            if (cepStore.address == null &&
                cepStore.error.isEmpty &&
                !cepStore.loading) {
              return Container();
            } else if (cepStore.address == null &&
                cepStore.error.isEmpty &&
                cepStore.loading) {
              return LinearProgressIndicator();
            } else if (cepStore.error != '') {
              return Container(
                alignment: Alignment.center,
                color: Colors.red.withAlpha(100),
                padding: const EdgeInsets.all(8),
                child: Text(
                  cepStore.error,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              );
            } else {
              final a = cepStore.address;

              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 50,
                width: 100,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Localização : ${a!.district}, ${a.city} = ${a.uf.initials}',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              );
            }
          })
        ],
      );
    });
  }
}
