import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/home/components/section_title.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OrderByField extends StatelessWidget {
  final FilterStore filter;
  const OrderByField({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    Widget buildOption(String title, OrderBy option) {
      return GestureDetector(
        onTap: () {
          filter.serOrderBy(option);
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: filter.orderBy == option
                  ? Colors.pink.shade300
                  : Colors.pink.shade100),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Ordenar Por:'),
        Observer(builder: (_) {
          return Row(
            children: [
              buildOption('Data', OrderBy.PRICE),
              const SizedBox(
                width: 12,
              ),
              buildOption('Preco', OrderBy.DATE),
            ],
          );
        })
      ],
    );
  }
}
