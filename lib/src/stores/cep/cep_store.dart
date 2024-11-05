import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/repositories/ibge_api/cep_repository.dart';

part 'cep_store.g.dart';

class CepStore = _CepStoreBase with _$CepStore;

abstract class _CepStoreBase with Store {
  @observable
  String cep = ''; // Inicializa com uma string vazia

  @observable
  Address? address;

  @action
  void setCep(String value) {
    cep = value;
    if (clearCep.length == 8) {
      _searchCep();
    } else {
      _reset();
    }
  }

  CepStore cepStore =
      CepStore(cep: '', address: null, error: '', loading: false);

  @computed
  String get clearCep => cep.replaceAll(RegExp('[^0-9]'), '');

  @observable
  String error = '';

  @observable
  bool loading = false;

  _CepStoreBase({
    required this.cep,
    required this.address,
    required this.error,
    required this.loading,
  }) {
    if (clearCep.length != 8) {
      _reset();
    } else {
      _searchCep();
    }
  }

  @action
  Future<void> _searchCep() async {
    loading = true;
    try {
      address = await CepRepository().getAddressFromApi(clearCep);
      error = '';
    } catch (e) {
      error = e.toString();
      address = null;
    } finally {
      loading = false;
    }
  }

  @action
  void _reset() {
    address = null;
    error = '';
  }
}
