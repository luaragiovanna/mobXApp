import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/models/ibge/uf.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

enum AdStatus { PENDING, ACTIVE, SOLD, DELETED }

class Ad {
  // Construtor para criar novos anúncios
  Ad({
    this.id,
    required this.user,
    required this.images,
    this.title = '',
    this.description = '',
    required this.category,
    this.price = 0,
    this.hidePhone = false,
    this.views = 0,
    this.status = AdStatus.PENDING,
    required this.createdAt,
  });

  // Construtor de fábrica para criar um anúncio a partir de um ParseObject
  factory Ad.fromParse(ParseObject object) {
    final parseUser = object.get<ParseUser>(keyAdOwner);
    if (parseUser == null) {
      throw Exception('Erro: usuário não encontrado no anúncio');
    }

    return Ad(
      id: object.objectId,
      user: UserRepository().mapParseToUser(parseUser),
      images: object.get<List>(keyAdImages)?.map((e) => e.url).toList() ?? [],
      title: object.get<String>(keyAdTitle) ?? '',
      description: object.get<String>(keyAdDescription) ?? '',
      category:
          CategoryModel.fromParse(object.get<ParseObject>(keyAdCategory)!),
      price: object.get<num>(keyAdPrice) ?? 0,
      hidePhone: object.get<bool>(keyAdHidePhone) ?? false,
      views: object.get<int>(keyAdViews, defaultValue: 0) ?? 0,
      status: AdStatus.values[object.get<int>(keyAdStatus) ?? 0],
      createdAt: object.createdAt ?? DateTime.now(),
    );
  }

  String? id;
  List images;
  String title;
  String description;
  CategoryModel category;
  Address address = Address(
      district: '',
      city: City(name: ''),
      cep: '',
      uf: Uf(initials: '', name: ''));
  num price;
  bool hidePhone;
  AdStatus status;
  DateTime createdAt;
  UserModel user;
  int views;
}
