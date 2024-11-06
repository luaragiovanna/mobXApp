// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/models/ibge/uf.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
// ignore: implementation_imports
import 'package:mobx/src/api/observable_collections.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

enum AdStatus { PENDING, ACTIVE, SOLD, DELETED }

class Ad {
  Ad.fromParse(ParseObject object) {
    id = object.objectId!;
    title = object.get<String>(keyAdTitle)!;
    description = object.get<String>(keyAdDescription)!;
    images = object.get<List>(keyAdImages)!.map((e) => e.url).toList();
    hidePhone = object.get<bool>(keyAdHidePhone)!;
    price = object.get<num>(keyAdPrice)!;
    created = object.createdAt!;
    address = Address(
      district: object.get<String>(keyAdDistrict)!,
      city: City(name: object.get<String>(keyAdCity)!),
      cep: object.get<String>(keyAdPostalCode)!,
      uf: Uf(initials: object.get<String>(keyAdFederativeUnit)!, name: ''),
    );
    views = object.get<int>(keyAdViews, defaultValue: 0)!;
    category = CategoryModel.fromParse(object.get<ParseObject>(keyAdCategory)!);
    status = AdStatus.values[object.get<int>(keyAdStatus)!];
    user = UserRepository().mapParseToUser(object.get<ParseUser>(
        keyAdOwner)!); // Garanta que 'user' é mapeado corretamente
  }

  Ad(
      {required UserModel user,
      required ObservableList images,
      required String id,
      required String title,
      required String description,
      required CategoryModel category,
      required num price,
      required DateTime createdDate,
      required bool hidePhone,
      required int views});

  late String id;

  late List images = [];

  late String title;
  late String description;

  late CategoryModel category;

  late Address address;

  late num price;
  late bool hidePhone = false;

  late AdStatus status = AdStatus.PENDING;
  late DateTime created;

  UserModel user = UserModel(
      name: '', email: '', phone: '', id: '', createdAt: DateTime.now());

  late int views;
}
