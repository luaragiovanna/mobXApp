import 'package:flutter/material.dart';

class PageTile extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  const PageTile(
      {super.key,
      required this.label,
      required this.iconData,
      required this.onTap,
      required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
            color: Color.fromARGB(255, 102, 3, 36),
            fontSize: 17,
            fontWeight: FontWeight.w600),
      ),
      leading: Icon(
        iconData,
        color: highlighted ? Colors.pink : Colors.pink.withOpacity(0.3),
      ),
      onTap: onTap,
    );
  }
}
