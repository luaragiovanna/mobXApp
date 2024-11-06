// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/ibge/address.dart';
import 'package:flutter_box_project/src/repositories/ad/ad_repository.dart';
import 'package:flutter_box_project/src/stores/cep/cep_store.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:flutter_box_project/src/models/category/category_model.dart';

part 'create_store.g.dart';

class CreateStore = _CreateStore with _$CreateStore;

abstract class _CreateStore with Store {
  late CepStore cepStore;

  ObservableList images =
      ObservableList(); //sempre q add uma nova img atualiza baloes

  @observable
  CategoryModel category = CategoryModel(id: '', description: '', name: '');

  @observable
  String title = '';

  @computed
  bool get titleValid => title.length >= 6;
  String get titleError {
    if (!showErrors || titleValid) {
      return '';
    } else if (title.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return 'Campo Obrigatorio';
    else
      // ignore: curly_braces_in_flow_control_structures
      return 'Titulo invalido';
  }

  @action
  void setTitle(String value) => title = value;

  @action
  void setCategory(CategoryModel value) => category = value;

  @computed
  bool get imagesValid =>
      images.isNotEmpty; //se tiver uma lista cm 1 img valido

  @computed
  String get imagesError {
    if (!showErrors || imagesValid)
      return '';
    else
      return 'Insira imagens';
  }

  @observable
  bool hidePhone = false;

  @computed
  bool get categoryValid => category.description.isNotEmpty;
  String get categoryError {
    if (!showErrors || categoryValid)
      return '';
    else
      return 'Campo obrigatório';
  }

  @computed
  Address? get address => cepStore.address;
  bool get addressValid => address != null;
  String get addressError {
    if (addressValid) {
      return '';
    } else {
      return 'Campo obrigatorio';
    }
  }

  //PRECO
  @observable
  String priceText = '';

  @action
  void setPrice(String value) => priceText = value;

  @computed
  num get price {
    if (priceText.contains('.')) {
      final parsedValue =
          num.tryParse(priceText.replaceAll(RegExp('[^0-9]'), ''));
      return (parsedValue ?? 0) / 100; // Se parsedValue for null, retorna 0.
    } else {
      final parsedValue = num.tryParse(priceText);
      return parsedValue?.toDouble() ??
          0; // Se parsedValue for null, retorna 0.
    }
  }

  bool get priceValid => price > 0 && price <= 999999;
  String get priceError {
    if (!showErrors || priceValid) {
      return '';
    } else if (priceText.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return 'Campo obrigatório';
    else
      // ignore: curly_braces_in_flow_control_structures
      return 'Valor inválido';
  }

  @action
  void setHidePhone(bool? value) {
    hidePhone = value ?? false; // Se o valor for null, define como false
  }

  @observable
  String description = '';

  @action
  void setDescription(String value) => description = value;

  @computed
  bool get descriptionValid => description.length >= 10;
  String get descriptionError {
    if (!showErrors || titleValid) {
      return '';
    } else if (description.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return 'Campo Obrigatorio';
    else
      // ignore: curly_braces_in_flow_control_structures
      return 'Descricao muito curto';
  }

  @computed
  bool get formValid => imagesValid && titleValid && descriptionValid;
  //categoryValid &&
  //addressValid &&
  //priceValid;

  // @computed
  // void Function()? get sendPressed => formValid ? _send : null;

  @computed
  void Function() get sendPressed => _send;

  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() {
    showErrors = false;
  }

  @observable
  bool loading = false;

  @observable
  String error = '';

  // void _send() async {
  //   final ad = Ad(
  //       user: GetIt.I<UserManagerStore>().userModel,
  //       images: images,
  //       id: '',
  //       title: title,
  //       description: description,
  //       category: category,
  //       price: price,
  //       createdDate: DateTime.now(),
  //       hidePhone: hidePhone,
  //       views: 0);
  //   error = 'Falha ao salvar';

  //   loading = true;
  //   try {
  //     final response = await AdRepository().save(ad);
  //   } catch (e) {
  //     error = e.toString();
  //   }
  //   loading = false;
  // }

  @observable
  bool savedAd = false;

  void _send() async {
    final ad = Ad(
        user: GetIt.I<UserManagerStore>().user,
        images: images,
        id: '',
        title: title,
        description: description,
        category: category,
        price: price,
        createdDate: DateTime.now(),
        hidePhone: hidePhone,
        views: 0);
    error = 'Falha ao salvar';

    loading = true;
    try {
      await AdRepository().save(ad);
      savedAd = true;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
  }
}
