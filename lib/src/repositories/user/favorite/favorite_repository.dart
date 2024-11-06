
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class FavoriteRepository {
  Future<List<Ad>> getFavorites(UserModel user) async { //lista de anuncios favoritados

  //precisa ter acesso ao usuario
  //criar query e traz todos favoritos desse usuario(objeto) 
    final queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));

    queryBuilder.whereEqualTo(keyFavoritesOwner, user.id); //keyFavOwn tem q ser igual ao id do usuario
    //vai pegar ponteiro do anuncio ad e traz objeto inteiro do ad
    queryBuilder.includeObject([keyFavoritesAd, 'ad.owner']);
    //retorna response e realiza query
    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!
          .map((po) => Ad.fromParse(po.get(keyFavoritesAd)))
          .toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code));
    }
  }

  Future<void> save({required Ad ad, required UserModel user}) async { //usuario e ad
    final favoriteObject = ParseObject(keyFavoritesTable);

    favoriteObject.set<String>(keyFavoritesOwner, user.id);
    favoriteObject.set<ParseObject>(
        keyFavoritesAd, ParseObject(keyAdTable)..set(keyAdId, ad.id));

    final response = await favoriteObject.save();
    if (!response.success)
      return Future.error(ParseErrors.getDescription(response.error!.code));
  }

  Future<void> delete({required Ad ad, required UserModel user}) async {
    try {
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));

      queryBuilder.whereEqualTo(keyFavoritesOwner, user.id);
      queryBuilder.whereEqualTo(
          keyFavoritesAd, ParseObject(keyAdTable)..set(keyAdId, ad.id));

      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        for (final f in response.results as List<ParseObject>) {
          await f.delete();
        }
      }
    } catch (e) {
      return Future.error('Falha ao deletar favorito');
    }
  }
}
