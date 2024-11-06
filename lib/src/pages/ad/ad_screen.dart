import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/stores/user/favorite_store.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

import 'components/bottom_bar.dart';
import 'components/description_panel.dart';
import 'components/location_panel.dart';
import 'components/main_panel.dart';
import 'components/user_panel.dart';

class AdScreen extends StatelessWidget {
  AdScreen(this.ad);

  final Ad ad;

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();
  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Anúncio'),
        centerTitle: true,
        actions: [
          if (ad.status == AdStatus.ACTIVE && userManagerStore.isLoggedIn)
            Observer(builder: (_) {
              return IconButton(
                icon: Icon(
                  favoriteStore.favoriteList.any((a) => a.id == ad.id) //AQ
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                onPressed: () => favoriteStore.toggleFavorite(ad),
              );
            })
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: 280,
                child: AnotherCarousel(
                  images: ad.images
                      .map((url) => CachedNetworkImageProvider(url))
                      .toList(),
                  dotColor: Colors.pink,
                  dotBgColor: Colors.transparent,
                  autoplay: true,
                  dotSize: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MainPanel(ad),
                    Divider(color: Colors.grey[500]),
                    DescriptionPanel(ad),
                    Divider(color: Colors.grey[500]),
                    LocationPanel(ad),
                    Divider(color: Colors.grey[500]),
                    UserPanel(ad),
                    SizedBox(
                      height: ad.status == AdStatus.PENDING ? 16 : 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
          BottomBar(ad),
        ],
      ),
    );
  }
}
