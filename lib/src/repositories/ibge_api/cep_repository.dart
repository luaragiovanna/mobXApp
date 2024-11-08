import 'package:dio/dio.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/repositories/ibge_api/ibge_repository.dart';

class CepRepository {
  Future<Address> getAddressFromApi(String cep) async {
    if (cep == null || cep.isEmpty) return Future.error('CEP Inválido');

    final clearCep = cep.replaceAll(RegExp('[^0-9]'), '');
    if (clearCep.length != 8) return Future.error('CEP Inválido');

    final endpoint = 'http://viacep.com.br/ws/$clearCep/json';

    try {
      final response = await Dio().get<Map>(endpoint);

      if (response.data!.containsKey('erro') && response.data!['erro'])
        return Future.error('CEP Inválido');

      final ufList = await IBGERepository().getUfList();

      return Address(
        cep: response.data!['cep'],
        district: response.data!['bairro'],
        city: City(name: response.data!['localidade']),
        uf: ufList.firstWhere((uf) => uf.initials == response.data!['uf']),
      );
    } catch (e) {
      return Future.error('Falha ao buscar CEP');
    }
  }
}
