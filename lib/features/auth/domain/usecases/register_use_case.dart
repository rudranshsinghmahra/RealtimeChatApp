import 'package:realtime_chat_app/features/auth/domain/entity/user_entity.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
