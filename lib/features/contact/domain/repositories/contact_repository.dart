import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<List<ContactEntity>> fetchContact();

  Future<void> addContact({required String email});
}
