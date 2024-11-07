class UserModel {
  UserModel({
    required this.id,
    required this.password,
    required this.name,
    required this.email,
    required this.phone,
    this.userType = UserType.PARTICULAR,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final DateTime createdAt;
  final String password;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, userType: $userType, createdAt: $createdAt)';
  }
}

enum UserType { PARTICULAR, PROFESSIONAL }
