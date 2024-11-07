import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/pages/ad/ad_screen.dart';
import 'package:flutter_box_project/src/pages/announcement/create/create_announcement.dart';
import 'package:flutter_box_project/src/stores/user/my_ads_store.dart';

class ActiveTile extends StatelessWidget {
  ActiveTile(this.ad, this.store);

  final Ad ad;
  final MyAdsStore store; //recebe a store por parametro e

  final List<MenuChoice> choices = [
    MenuChoice(index: 0, title: 'Editar', iconData: Icons.edit),
    MenuChoice(index: 1, title: 'Já vendi', iconData: Icons.thumb_up),
    MenuChoice(index: 2, title: 'Excluir', iconData: Icons.delete)
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AdScreen(ad)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          height: 80,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: ad.images.isEmpty
                      ? 'https://static.thenounproject.com/png/194055-200.png'
                      : ad.images.first,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ad.title!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        //ad.price.formattedMoney(),
                        '',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '${ad.views} visitas',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  PopupMenuButton<MenuChoice>(
                    onSelected: (choice) {
                      switch (choice.index) {
                        case 0:
                          editAd(context);
                          break;
                        case 1:
                          soldAd(context);
                          break;
                        case 2:
                          deleteAd(context);
                          break;
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: Colors.purple,
                    ),
                    itemBuilder: (_) {
                      return choices
                          .map(
                            (choice) => PopupMenuItem<MenuChoice>(
                              value: choice,
                              child: Row(
                                children: [
                                  Icon(
                                    choice.iconData,
                                    size: 20,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    choice.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editAd(BuildContext context) async {
    final success = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateAnnouncement(ad: ad), //se for sucesso refreseh
      ),
    );
    if (success != null && success) store.refresh();
  }

  Future<void> soldAd(BuildContext context) async {
    //se foi vendido nao mostra dialogo caixa
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Produto Vendido'),
        content: Text('Confirmar a venda de ${ad.title}?'),
        actions: [
          ElevatedButton(
            onPressed: Navigator.of(context).pop, //fecha dialogo
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); //tbm fecha
              store.soldAd(ad);
            },
            child: Text('Sim'),
          ),
        ],
      ),
    );
  }

  void deleteAd(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir'),
        content: Text('Confirmar a exclusão de ${ad.title}?'),
        actions: [
          ElevatedButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              //chamada da store ad
              store.deleteAd(ad);
            },
            child: Text('Sim'),
          ),
        ],
      ),
    );
  }
}

class MenuChoice {
  MenuChoice(
      {required this.index, required this.title, required this.iconData});

  final int index;
  final String title;
  final IconData iconData;
}
