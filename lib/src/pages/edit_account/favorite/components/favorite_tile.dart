import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/helpers/extensions.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/pages/ad/ad_screen.dart';
import 'package:flutter_box_project/src/stores/user/favorite_store.dart';

class FavoriteTile extends StatelessWidget {
  final Ad? ad;
  final FavoriteStore favoriteStore;
  const FavoriteTile(
      {super.key,  this.ad, required this.favoriteStore}); //recebe anuncio como parametro

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AdScreen(ad!)));
      },
      child: Container(
        height: 135,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Row(
            children: [
              SizedBox(
                height: 135,
                width: 127,
                child: CachedNetworkImage(
                  imageUrl: ad!.images.isEmpty
                      ? 'https://static.thenounproject.com/png/194055-200.png'
                      : ad!.images.first,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ad!.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ad!.price.formattedMoney(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${ad!.created.formattedDate()} - '
                              '${ad!.address.city.name} - '
                              '${ad!.address.uf.initials}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => favoriteStore.toggleFavorite(ad!),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
