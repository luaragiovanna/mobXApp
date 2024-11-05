import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/page_section/page_tile.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:get_it/get_it.dart';

class CustomPageSection extends StatelessWidget {
  final PageStore pageStore = GetIt.I<PageStore>();

  CustomPageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageTile(
            label: 'Anúncios',
            iconData: Icons.list_alt,
            onTap: () {
              pageStore.setPage(0);
            },
            highlighted: pageStore.page == 0),
        PageTile(
            label: 'Favoritos',
            iconData: Icons.favorite,
            onTap: () {
              pageStore.setPage(1);
            },
            highlighted: pageStore.page == 0),
        PageTile(
            label: 'Inserir Anúncio',
            iconData: Icons.post_add,
            onTap: () {
              pageStore.setPage(2);
            },
            highlighted: pageStore.page == 0),
        PageTile(
            label: 'Chat',
            iconData: Icons.chat,
            onTap: () {
              pageStore.setPage(3);
            },
            highlighted: pageStore.page == 0),
        PageTile(
            label: 'Perfil',
            iconData: Icons.person,
            onTap: () {
              pageStore.setPage(4);
            },
            highlighted: pageStore.page == 0),
      ],
    );
  }
}
