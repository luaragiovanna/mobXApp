import 'dart:io';

import 'package:flutter_box_project/src/models/ad/ad.dart' as ad;
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path/path.dart' as path;

class AdRepository {
  Future<List<ad.Ad>> getHomeAdList({
    required FilterStore filter,
    required String search,
    required CategoryModel category,
    required int page,
  }) async {
    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));

      queryBuilder.includeObject([keyAdOwner, keyAdCategory]);

      queryBuilder.setAmountToSkip(page * 10);
      queryBuilder.setLimit(10);

      queryBuilder.whereEqualTo(keyAdStatus, AdStatus.ACTIVE.index);

      if (search.isNotEmpty && search.trim().isNotEmpty) {
        queryBuilder.whereContains(keyAdTitle, search, caseSensitive: false);
      }

      if (category.id != '*') {
        queryBuilder.whereEqualTo(
          keyAdCategory,
          (ParseObject(keyCategoryTable)..set(keyCategoryId, category.id))
              .toPointer(),
        );
      }

      switch (filter.orderBy) {
        case OrderBy.PRICE:
          queryBuilder.orderByAscending(keyAdPrice);
          break;
        case OrderBy.DATE:
        default:
          queryBuilder.orderByDescending(keyAdCreatedAt);
          break;
      }

      if (filter.minPrice != null && filter.minPrice > 0) {
        queryBuilder.whereGreaterThanOrEqualsTo(keyAdPrice, filter.minPrice);
      }

      if (filter.maxPrice != null && filter.maxPrice > 0) {
        queryBuilder.whereLessThanOrEqualTo(keyAdPrice, filter.maxPrice);
      }

      if (filter.vendorType > 0 &&
          filter.vendorType <
              (VENDOR_TYPE_PROFESSIONAL | VENDOR_TYPE_PARTICULAR)) {
        final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery());

        if (filter.vendorType == VENDOR_TYPE_PARTICULAR) {
          userQuery.whereEqualTo(keyUserType, UserType.PARTICULAR.index);
        }

        if (filter.vendorType == VENDOR_TYPE_PROFESSIONAL) {
          userQuery.whereEqualTo(keyUserType, UserType.PROFESSIONAL.index);
        }

        queryBuilder.whereMatchesQuery(keyAdOwner, userQuery);
      }

      final response = await queryBuilder.query();
      if (response.success && response.results != null) {
        return response.results!.map((po) => ad.Ad.fromParse(po)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    } catch (e) {
      return Future.error('Falha de conexão');
    }
  }

  Future<void> save(ad.Ad ad) async {
    try {
      final parseImages = await saveImages(ad.images);

      final parseUser = ParseUser('', '', '')..set(keyUserId, ad.user.id);

      final adObject = ParseObject(keyAdTable);

      if (ad.id != null) adObject.objectId = ad.id; // Apenas se o ID existir

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);
      adObject.setACL(parseAcl);

      adObject.set<String>(keyAdTitle, ad.title!);
      adObject.set<String>(keyAdDescription, ad.description!);
      adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
      adObject.set<num>(keyAdPrice, ad.price);
      adObject.set<int>(keyAdStatus, ad.status.index);
      adObject.set<String>(keyAdDistrict, ad.address.district);
      adObject.set<String>(keyAdCity, ad.address.city.name);
      adObject.set<String>(keyAdFederativeUnit, ad.address.uf.initials);
      adObject.set<String>(keyAdPostalCode, ad.address.cep);
      adObject.set<List<ParseFile>>(keyAdImages, parseImages);
      adObject.set<ParseUser>(keyAdOwner, parseUser);
      adObject.set<ParseObject>(keyAdCategory,
          ParseObject(keyCategoryTable)..set(keyCategoryId, ad.category.id));

      final response = await adObject.save();

      if (!response.success) {
        throw Exception(ParseErrors.getDescription(response.error!.code));
      }

      // Atualize o ID do anúncio após o salvamento
      ad.id = adObject.objectId!;
    } catch (e) {
      print(e);
      throw Exception('Falha ao salvar anúncio');
    }
  }

  Future<List<ParseFile>> saveImages(List images) async {
    final parseImages = <ParseFile>[];

    try {
      for (final image in images) {
        if (image is File) {
          final parseFile = ParseFile(image, name: path.basename(image.path));
          final response = await parseFile.save();
          if (!response.success) {
            return Future.error(
                ParseErrors.getDescription(response.error!.code));
          }
          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null);
          parseFile.name = path.basename(image);
          parseFile.url = image;
          parseImages.add(parseFile);
        }
      }

      return parseImages;
    } catch (e) {
      return Future.error('Falha ao salvar imagens');
    }
  }

  Future<List<ad.Ad>> getMyAds(UserModel user) async {
    final currentUser = ParseUser('', '', '')..set(keyUserId, user.id);
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));

    queryBuilder.setLimit(100);
    queryBuilder.orderByDescending(keyAdCreatedAt);
    queryBuilder.whereEqualTo(keyAdOwner, currentUser.toPointer());
    queryBuilder.includeObject([keyAdCategory, keyAdOwner]);

    final response = await queryBuilder.query();
    if (response.success && response.results != null) {
      return response.results!.map((po) => ad.Ad.fromParse(po)).toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code));
    }
  }

  Future<void> sold(ad.Ad ad) async {
    //pega referencia do objeto q esta como vendido
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);
    //setar status do objeto
    parseObject.set(keyAdStatus, AdStatus.SOLD.index);
    //salvar nova alteracao
    final response = await parseObject.save();
    if (!response.success)
      return Future.error(ParseErrors.getDescription(response.error!.code));
  }

  Future<void> delete(ad.Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);

    parseObject.set(
        keyAdStatus,
        AdStatus.DELETED
            .index); //só altera o status assim some pro usuario mas mantem no banco

    final response = await parseObject.save();
    if (!response.success)
      return Future.error(ParseErrors.getDescription(response.error!.code));
  }
}
