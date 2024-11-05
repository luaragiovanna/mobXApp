// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HidephoneField extends StatelessWidget {
  final CreateStore createStore;
  HidephoneField({
    Key? key,
    required this.createStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Observer(builder: (_) {
            return Checkbox(
              activeColor: Colors.pink,
              checkColor: Colors.red,
              value: createStore.hidePhone,
              onChanged: (bool? value) {
                createStore.setHidePhone(value); // Agora 'value' pode ser null
              },
            );
          }),
          const Expanded(
              child: Text('Não quero que vejam meu número neste anúncio')),
        ],
      ),
    );
  }
}
