import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/home/components/section_title.dart';
import 'package:flutter_box_project/src/pages/home/filter/price_field.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PriceRangeField extends StatelessWidget {
  final FilterStore filterStore;
  const PriceRangeField({super.key, required this.filterStore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Preço'),
        Row(
          children: [
            PriceField(
              label: '',
              onChanged: filterStore.setMinPrice,
              initialValue: filterStore.minPrice,
            ),
            SizedBox(
              width: 2,
            ),
            PriceField(
              label: '',
              onChanged: filterStore.setMaxPrice,
              initialValue: filterStore.maxPrice,
            ),
          ],
        ),
        Observer(builder: (_) {
          if (filterStore.priceError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                filterStore.priceError,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            );
          }
          return Container();
        })
      ],
    );
  }
}
