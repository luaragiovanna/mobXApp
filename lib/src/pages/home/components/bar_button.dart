import 'package:flutter/material.dart';

class BarButton extends StatelessWidget {
  final BoxDecoration decoration;
  final String label;
  final VoidCallback onTap;
  const BarButton(
      {super.key,
      required this.decoration,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          height: 40,
          child: Text(
            label,
            style: TextStyle(
                color: Colors.pink.shade200,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
