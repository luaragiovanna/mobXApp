import 'dart:io';

import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path/path.dart' as path;

class AdRepository {
  // Future<Object?> save(Ad ad) async {
  //   try {
  //     //salvar imgs do anuncio pro parseServe e cria objeto parseFIle
  //     final parseImages = await saveImages(ad.images);
  //     //obter usuario atual do AD
  //     final parseUser = ParseUser('', '', '')
  //       ..set(keyUserId, ad.user!.id); //usuario vinculado ao anuncio
  //     //anuncio salvo no parseServe
  //     final adObject =
  //         ParseObject(keyAdTable); //parseobject presente na tabela ad

  //     //permissoes do objeto
  //     final parseAcl = ParseACL(owner: parseUser); //dono é o usuario
  //     parseAcl.setPublicReadAccess(
  //         allowed: true); //qulauqer um pode ler dados do anuncio
  //     parseAcl.setPublicWriteAccess(allowed: false);
  //     adObject.setACL(
  //         parseAcl); //se objeto está associoado com parse (ex parseUser) objeto só vai ler e escrever atraves desse usuario
  //     adObject.set<String>(keyAdTitle, ad.title);
  //     adObject.set<String>(keyAdDescription, ad.description);
  //     adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
  //     adObject.set<num>(keyAdPrice, ad.price);
  //     adObject.set<int>(keyAdStatus,
  //         ad.status.index); //enum n da pra colocar tem q ser int e index deles
  //     //ENDERECO
  //     //adObject.set<String>(keyAdDistrict, ad.address.district);
  //     // adObject.set<String>(keyAdCity, ad.address.city.name);
  //     // adObject.set<String>(keyAdFederativeUnit, ad.address.uf.initials);
  //     // adObject.set<String>(keyAdPostalCode, ad.address.cep);

  //     adObject.set<List<ParseFile>>(keyAdImages, parseImages);
  //     adObject.set<ParseUser>(keyAdOwner, parseUser);

  //     //CATEGORIAS
  //     adObject.set<ParseObject>(
  //         keyAdCategory,
  //         ParseObject(keyCategoryTable)
  //           ..set(keyCategoryId,
  //               ad.category.id)); //relacao entre objeto anuncio e categoria
  //     final response = await adObject.save();

  //     if (response.success) {
  //       print(response.success);
  //       return response.results;
  //     } else {
  //       return Future.error(ParseErrors.getDescription(response.error!.code));
  //     }
  //   } catch (e) {
  //     return Future.error('Falha ao salvar anuncio');
  //   }
  // }

  Future<void> save(Ad ad) async {
    try {
      // Salvar as imagens
      final parseImages = await saveImages(ad.images!);
      final parseUser = ParseUser('', '', '')..set(keyUserId, ad.user!.id);

      final adObject = ParseObject(keyAdTable);

      // Definir permissões de leitura e escrita
      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);
      adObject.setACL(parseAcl);

      // Definir os campos do anúncio
      adObject.set<String>(keyAdTitle, ad.title);
      adObject.set<String>(keyAdDescription, ad.description);
      adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
      adObject.set<num>(keyAdPrice, ad.price);
      adObject.set<int>(keyAdStatus, ad.status.index);

      adObject.set<List<ParseFile>>(keyAdImages, parseImages);
      adObject.set<ParseUser>(keyAdOwner, parseUser);

      adObject.set<ParseObject>(
        keyAdCategory,
        ParseObject(keyCategoryTable)..set(keyCategoryId, ad.category!.id),
      );

      final response = await adObject.save();

      if (!response.success) {
        // Aqui você verifica se response.error não é nulo
        if (response.error != null) {
          return Future.error(ParseErrors.getDescription(response.error!.code));
        } else {
          return Future.error('Erro desconhecido ao salvar anúncio.');
        }
      }
    } catch (e) {
      return Future.error('Falha ao salvar anúncio: $e');
    }
  }

  Future<List<ParseFile>> saveImages(List images) async {
    final parseImages = <ParseFile>[];
    try {
      for (final image in images) {
        if (image is File) {
          // Subir para o Parse
          final parseFile = ParseFile(image, name: path.basename(image.path));
          final response = await parseFile.save();

          if (!response.success) {
            return Future.error(
                'Erro ao salvar imagem: ${response.error!.message}');
          }

          parseImages.add(parseFile);
        } else {
          // Se a imagem já é uma URL
          final parseFile = ParseFile(null)
            ..name = path.basename(image)
            ..url = image;
          parseImages.add(parseFile);
        }
      }
    } catch (e) {
      return Future.error('Erro ao processar imagens: $e');
    }
    return parseImages; // Retorna a lista de imagens processadas
  }
}
