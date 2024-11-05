// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:flutter_box_project/src/repositories/user/user_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Ad {
  late String id;
  late List? images;
  late String title;
  late String description;
  late CategoryModel? category;
  //Address address;
  late num price;
  late bool hidePhone;
  late AdStatus status = AdStatus.PENDING;
  late DateTime createdDate;
  late UserModel? user;
  late int views;

  Ad({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.hidePhone,
    required this.createdDate,
    required this.user,
    required this.views,
  });

  Ad.fromParse(ParseObject object) {
    id = object.objectId!;
    title = object.get<String>(keyAdTitle)!;
    description = object.get<String>(keyAdDescription)!;
    images = object.get<List>(keyAdImages)!.map((e) => e.url).toList();
    hidePhone = object.get<bool>(keyAdHidePhone)!;
    price = object.get<num>(keyAdPrice)!;
    createdDate = object.createdAt!;
    //address = Address(district: object.get<String>(keyAdDistrict),)
    views = object.get<int>(keyAdViews, defaultValue: 0)!;
    user = UserRepository().mapParseToUser(object.get<ParseUser>(keyAdOwner)!);
    category = CategoryModel.fromParse(object.get<ParseObject>(keyAdCategory)!);
    status = AdStatus.values[object.get<int>(keyAdStatus)!];
  }
}

enum AdStatus { PENDING, ACTIVE, SOLD, DELETED } // 0  1 2 3 4
