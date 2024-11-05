// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_box_project/src/models/ibge/city.dart';
import 'package:flutter_box_project/src/models/ibge/uf.dart';

class Address {
  Uf uf;
  City city;
  String cep;
  String district;
  Address({
    required this.uf,
    required this.city,
    required this.cep,
    required this.district,
  });

  @override
  String toString() {
    return 'Address(uf: $uf, city: $city, cep: $cep, district: $district)';
  }
}
