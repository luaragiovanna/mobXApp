import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/models/ibge/uf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IBGERepository {
  Future<List<Uf>> getUFListFromApi() async {
    final preferences =
        await SharedPreferences.getInstance(); //armazena dados simples
    if (preferences.containsKey('UF_LIST')) {
      print('FOUND CACHE');
      final j = json.decode(preferences.get('UF_LIST') as String);
      return j.map<Uf>((json) => Uf.fromJson(json)).toList()
        ..sort((Uf a, Uf b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    print('NOT FOUND ON CACHE');

    const ednpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

    try {
      final response = await Dio().get<List>(ednpoint);
      final ufList = response.data!
          .map<Uf>((json) => Uf.fromJson(json))
          .toList()
        ..sort((Uf a, Uf b) => a.name.toLowerCase().compareTo(b.name
            .toLowerCase())); //mapear cada um dos json em objeto UF E COLOCAR NO UFLIST

      preferences.setString('UF_LIST', json.encode(response.data));
      return ufList;
    } on DioException {
      return Future.error('Falha ao obter lista de estados');
    }
  }

  Future<List<City>> getCityListFromApi(Uf uf) async {
    final String endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.id}/municipios';

    try {
      final response = await Dio().get<List>(endpoint); //lista de municipios
      final cityList = response.data!
          .map<City>((e) => City.fromJson(e))
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return cityList;
    } on DioException {
      return Future.error('');
    }
  }
}
