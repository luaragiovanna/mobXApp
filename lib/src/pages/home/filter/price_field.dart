import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatelessWidget {
  final Function(int) onChanged;
  final String label;
  final int initialValue;

  PriceField(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        onChanged: (text) {
          //passar pro priceRangeFilter pra settar fora do pricefield
          //onChanged(int.tryParse(text.replaceAll('.', ''))!);
        },
        initialValue: initialValue.toString(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          isDense: true,
          labelText: label,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          RealInputFormatter(moeda: true),
        ],
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
