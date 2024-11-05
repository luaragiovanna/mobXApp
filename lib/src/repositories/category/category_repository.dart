import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/repositories/error/parse_errors.dart';
import 'package:flutter_box_project/src/repositories/user/keys/table_keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getList() async {
    // Criação do QueryBuilder
    final queryBuilder = QueryBuilder(ParseObject(keyCategoryTable))
      ..orderByAscending(keyCategoryDescription);

    // Realiza a consulta
    final response = await queryBuilder.query();

    if (response.success) {
      // Mapeia os resultados para uma lista de CategoryModel
      return response.results!
          .map((e) => CategoryModel.fromParse(e))
          .toList()
          .cast<CategoryModel>();
    } else {
      throw ParseErrors.getDescription(response.error!.code);
    }
  }
}
