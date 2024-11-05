// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';

class CategoryModel {
   late String id;
   late String description;
  CategoryModel({
      required this.id,
      required this.description,
  });

  CategoryModel.fromParse(ParseObject parseObject) {
    id = parseObject.objectId!;
    description = parseObject.get(keyCategoryDescription);
  } //manda objeto parse e retorna um novo objeto category

  

  @override
  String toString() => 'CategoryModel(id: $id, description: $description)';
}
