import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class FetchContactUseCases {
  final ContactRepository contactRepository;

  FetchContactUseCases({required this.contactRepository});

  Future<List<ContactEntity>> call() async {
    return await contactRepository.fetchContact();
  }
}
