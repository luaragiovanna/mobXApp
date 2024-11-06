import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/card/empty_card.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/pages/edit_account/favorite/components/favorite_tile.dart';
import 'package:flutter_box_project/src/stores/user/favorite_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({this.hideDrawer = false});

  final bool hideDrawer;

  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(22)),
        ),
        title: const Text('Favoritos'),
        centerTitle: true,
      ),
      drawer: hideDrawer ? null : const CustomDrawer(),
      body: Observer(
        builder: (_) {
          if (favoriteStore.favoriteList.isEmpty)
            return const EmptyCard(
              text: 'Nenhum anúncio favoritado.',
            );

          return ListView.builder(
            padding: EdgeInsets.all(2),
            itemCount: favoriteStore.favoriteList.length,
            itemBuilder: (_, index) => FavoriteTile(
              favoriteStore: favoriteStore,
            ), //img dados do anuncio e botao pra exluir fav
          );
        },
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
