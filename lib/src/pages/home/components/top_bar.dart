// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/annotations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/pages/category/category_page.dart';
import 'package:flutter_box_project/src/pages/home/components/bar_button.dart';
import 'package:flutter_box_project/src/pages/home/filter/filter_page.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:flutter_box_project/src/stores/home/home_store.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  final HomeStore homeStore = GetIt.I<HomeStore>();
  final FilterStore filterStore = GetIt.I<FilterStore>();

  CategoryModel categoryModel;
  TopBar({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Observer(builder: (_) {
          return BarButton(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.pink.shade100),
              ),
            ),
            label: homeStore.category?.description ?? 'Categorias',
            onTap: () {
              // Atualizar a categoria no homeStore antes de navegar
              if (categoryModel.id.isEmpty ||
                  categoryModel.description.isEmpty) {
                homeStore.setCategory(categoryModel);
              }

              // Realizar a navegação para a CategoryPage
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryPage(
                    showAll: true,
                    selected: categoryModel!,
                  ),
                ),
              );
            },
          );
        }),
        BarButton(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.pink.shade100),
                  left: BorderSide(color: Colors.pink.shade100))),
          label: 'Filtros',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => FilterPage(
                      filterStore: filterStore,
                    )));
          },
        )
      ],
    );
  }
}
