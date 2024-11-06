import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/home/components/section_title.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';

class VendorTypeField extends StatelessWidget {
  const VendorTypeField(FilterStore filterStore, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionTitle(
          title: 'Tipo de anunciante',
          
        ),
      ],
    );
  }
}
