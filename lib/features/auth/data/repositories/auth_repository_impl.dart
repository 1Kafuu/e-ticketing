import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/role_enum.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart'; 

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<UserEntity?> login(String email, String password) async {
    // SIMULASI: Cek login
    if (email == "admin@mail.com" && password == "admin123") {
      final user = UserModel(
        id: "USR-001",
        name: "Administrator",
        email: email,
        role: UserRole.admin,
      );
      await localDataSource.saveUser(user.toJson());
      return user; // UserModel otomatis dianggap sebagai UserEntity karena inheritance
    } else if (email == "user@mail.com" && password == "user123") {
      final user = UserModel(
        id: "USR-002",
        name: "Kafuu",
        email: email,
        role: UserRole.user,
      );
      await localDataSource.saveUser(user.toJson());
      return user;
    }
    return null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Repository memanggil DataSource untuk ambil data mentah
    final userMap = await localDataSource.getUser();
    if (userMap != null) {
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }
}