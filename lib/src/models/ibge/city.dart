// ignore_for_file: public_member_api_docs, sort_constructors_first
class City {
  int? id;
  String name;
  City({
    this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) =>
      City(id: json['id'], name: json['nome']);

  @override
  String toString() => 'City(id: $id, name: $name)';
}
