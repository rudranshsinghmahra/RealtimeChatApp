import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class FetchRecentContactUseCase {
  final ContactRepository contactRepository;

  FetchRecentContactUseCase({required this.contactRepository});

  Future<List<ContactEntity>> call() async {
    return await contactRepository.fetchContact();
  }
}
