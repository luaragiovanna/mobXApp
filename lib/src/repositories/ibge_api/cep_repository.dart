import 'package:dio/dio.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/repositories/ibge_api/ibge_repository.dart';

class CepRepository {
  Future<Address> getAddressFromApi(String cep) async {
    if (cep == null || cep.isEmpty) {
      return Future.error('CEP inválido');
    }
    final cleanCEP = cep.replaceAll(RegExp('[^0-9]'), '');
    if (cleanCEP.length != 8) return Future.error('CEP inválido');

    final endpoint = 'http://viacep.com.br/ws/$cleanCEP/json';

    try {
      final response = await Dio().get<Map>(endpoint);

      if (response.data!.containsKey('erro') && response.data!['erro']) {
        return Future.error('CEP inválido');
      }

      final ufList = await IBGERepository().getUFListFromApi();

      // Criando o objeto `City` corretamente
      final cityName = response.data!['localidade'];
      final city =
          City(name: cityName, id: 0); // A cidade agora é um objeto City

      return Address(
        uf: ufList.firstWhere((uf) =>
            uf.initials == response.data!['uf']), // Obtendo a UF pela sigla
        city: city, // Agora, 'city' é um objeto do tipo 'City'
        cep: response.data!['cep'],
        district: response.data!['bairro'],
      );
    } catch (e) {
      return Future.error('Falha ao buscar CEP');
    }
  }
}
