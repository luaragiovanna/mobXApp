// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/home/components/vendor_type_field.dart';

import 'package:flutter_box_project/src/pages/home/filter/order_by_field.dart';
import 'package:flutter_box_project/src/pages/home/filter/price_range_field.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';

class FilterPage extends StatelessWidget {
  FilterStore filterStore;
  FilterPage({
    Key? key,
    required this.filterStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    filterStore.orderBy; //ja tem acesso ao orderbyselecionado
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
        title: const Text(
          'FIltrar busca',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                OrderByField(
                  filter: filterStore,
                ),
                PriceRangeField(
                  filterStore: filterStore,
                ),
                VendorTypeField(filterStore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
