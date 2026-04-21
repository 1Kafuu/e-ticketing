import '../../domain/entities/user_entity.dart';
import '../../domain/entities/role_enum.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.profileImage,
  });

  // Pindahkan logika dari Entity ke sini
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'user'),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'profileImage': profileImage,
    };
  }
}