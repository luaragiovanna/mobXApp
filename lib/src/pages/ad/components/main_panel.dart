import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/helpers/extensions.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';

class MainPanel extends StatelessWidget {
  MainPanel(this.ad);

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 14),
          child: Text(
            ad.price.formattedMoney(),
            style: TextStyle(
              fontSize: 34,
              letterSpacing: 2.8,
              fontWeight: FontWeight.w300,
              color: Colors.grey[800],
            ),
          ),
        ),
        Text(
          ad.title!,
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 18),
          child: Text(
            'Publicado em ${ad.createdAt.formattedDate()}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
