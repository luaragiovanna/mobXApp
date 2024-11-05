// ignore_for_file: public_member_api_docs, sort_constructors_first
class Uf {
  int id;
  String initials;
  String name;
  Uf({
    required this.id,
    required this.initials,
    required this.name,
  });

  //đactory metodo cria novo objet
  factory Uf.fromJson(Map<String, dynamic> json) =>
      Uf(id: json['id'], initials: json['sigla'], name: json['nome']);
  //api recebe lista de json e cada objeto componente de estado e vai virar objeto uf

  @override
  String toString() => 'Uf(id: $id, initials: $initials, name: $name)';
}
