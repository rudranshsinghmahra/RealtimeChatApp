import 'package:realtime_chat_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:realtime_chat_app/features/auth/domain/entity/user_entity.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImplementation({required this.authRemoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register(
    String username,
    String email,
    String password,
  ) async {
    return await authRemoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
