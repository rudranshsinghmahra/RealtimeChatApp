import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasource/contact_remote_data_source.dart';

class ContactRepositoryImplementation implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<void> addContact({required String email}) async {
    await remoteDataSource.addContact(email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContact() async {
    return await remoteDataSource.fetchContact();
  }
}
