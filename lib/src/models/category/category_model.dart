import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.description,
    required this.name,
  });

  // Construtor de fábrica para instanciar `CategoryModel` a partir de um ParseObject
  factory CategoryModel.fromParse(ParseObject parseObject) {
    return CategoryModel(
      id: parseObject.objectId!,
      description: parseObject.get(keyCategoryDescription),
      name: parseObject.get(keyAdTitle),
    );
  }

  final String id;
  final String description;
  final String name;

  @override
  String toString() =>
      'CategoryModel(id: $id, description: $description, name: $name)';
}
