import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getList() async {
    final queryBuilder = QueryBuilder(ParseObject(keyCategoryTable))
      ..orderByAscending(keyCategoryDescription);

    final response = await queryBuilder.query();

    if (response.success) {
      return response.results!.map((p) => CategoryModel.fromParse(p)).toList();
    } else {
      throw ParseErrors.getDescription(response.error!.code);
    }
  }
}
