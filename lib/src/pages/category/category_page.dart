
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/stores/category/category_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CategoryPage extends StatelessWidget {
  final CategoryStore categoryStore = GetIt.I<CategoryStore>();
  final CategoryModel selected;
  final bool showAll;

  CategoryPage({super.key, required this.selected, this.showAll = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 14,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.fromLTRB(32, 12, 32, 32),
          child: Observer(builder: (_) {
            if (categoryStore.error != null) {
              return ErrorBox(message: categoryStore.error.toString());
            } else if (categoryStore.categoryList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final categories = showAll
                  ? categoryStore.allCategoryList
                  : categoryStore.categoryList;
              return ListView.separated(
                itemCount: categories.length,
                itemBuilder: (BuildContext _, int index) {
                  final category = categories[index];
                  return InkWell(
                    onTap: () {
                      // Ao tocar em uma categoria, retorna ela para a tela anterior
                      Navigator.of(context).pop(category);
                    },
                    child: Container(
                      height: 50,
                      color: category.id == selected?.id
                          ? const Color.fromARGB(
                              255, 249, 226, 234) // Cor de destaque
                          : null,
                      alignment: Alignment.center,
                      child: Text(
                        category.description!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: category.id == selected?.id
                              ? Color.fromARGB(
                                  255, 127, 91, 106) // Cor de texto selecionado
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext _, __) {
                  return Divider(
                    height: 0.1,
                    color: Colors.grey.withAlpha(50),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
