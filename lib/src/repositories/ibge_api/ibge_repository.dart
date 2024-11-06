import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_box_project/src/models/ibge/uf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ibge/city.dart';

class IBGERepository {
  Future<List<Uf>> getUfList() async {
    final preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('Uf_LIST')) {
      final j = json.decode(preferences.get('Uf_LIST').toString());

      return j.map<Uf>((j) => Uf.fromJson(j)).toList()
        ..sort((Uf a, Uf b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    const endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

    try {
      final response = await Dio().get<List>(endpoint);

      preferences.setString('Uf_LIST', json.encode(response.data));

      return response.data!.map<Uf>((j) => Uf.fromJson(j)).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } on DioException {
      return Future.error('Falha ao obter lista de Estados');
    }
  }

  Future<List<City>> getCityListFromApi(Uf Uf) async {
    final String endpoint =
        'http://servicodados.ibge.gov.br/api/v1/localidades/estados/${Uf.id}/municipios';

    try {
      final response = await Dio().get<List>(endpoint);

      final cityList = response.data!
          .map<City>((j) => City.fromJson(j))
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return cityList;
    } on DioException {
      return Future.error('Falha ao obter lista de Cidades');
    }
  }
}
