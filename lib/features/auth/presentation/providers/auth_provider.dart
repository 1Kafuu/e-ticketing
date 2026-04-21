import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../../../core/providers/shared_prefs_provider.dart';

// AuthLocalDataSource provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: prefs);
});

// AuthRepository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(localDataSource: dataSource);
});

// Ganti StateProvider dengan NotifierProvider
final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserEntity?>(() {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends Notifier<UserEntity?> {
  @override
  UserEntity? build() {
    return null; // State awal adalah null
  }

  // Fungsi untuk update state user (misal setelah login)
  void setUser(UserEntity? user) {
    state = user;
  }
}