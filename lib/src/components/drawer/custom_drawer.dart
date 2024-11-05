import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer_header.dart';
import 'package:flutter_box_project/src/components/page_section/custom_page_section.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.68, //pega altura da tela
        child: Drawer(     
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          child: ListView(
            children: [CustomDrawerHeader(), CustomPageSection()],
          ),
        ),
      ),
    );
  }
}
