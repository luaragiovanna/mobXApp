import 'package:flutter/material.dart';

class FildeTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const FildeTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3, bottom: 4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.pink.shade300,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.pink.shade300, fontSize: 12),
          )
        ],
      ),
    );
  }
}
