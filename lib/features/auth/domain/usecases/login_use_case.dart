import 'package:realtime_chat_app/features/auth/domain/entity/user_entity.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
