import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/category/category_page.dart';
import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CategoryField extends StatelessWidget {
  final CreateStore createStore;
  const CategoryField({super.key, required this.createStore});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          ListTile(
            title: createStore.category.id.isEmpty
                ? const Text(
                    'Categorias',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17),
                  )
                : Text(
                    createStore
                        .category.description, // Exibe a descrição da categoria
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 17),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              final category = await showDialog(
                context: context,
                builder: (_) => CategoryPage(
                  selected: createStore.category,
                  showAll: false,
                ),
              );
              if (category != null) {
                createStore.setCategory(category);
              }
            },
          ),
          if (createStore.categoryError != null)
            Container(
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.red),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 3),
              child: Text(
                createStore.categoryError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            )
          else
            Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey))),
            ),
        ],
      );
    });
  }
}
