import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String name;
  String email;
  String phone;
  String password;
  UserType userType;
  String id;
  DateTime createdAt;
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
     this.password = '',
    this.userType = UserType.PARTICULAR,
    required this.id,
    required this.createdAt,
  });

 

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, password: $password, userType: $userType, id: $id, createdAt: $createdAt)';
  }
}

enum UserType { PARTICULAR, PROFESSIONAL }
