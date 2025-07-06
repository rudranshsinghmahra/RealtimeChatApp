import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<void> addContact({required String email});

  Future<List<ContactEntity>> fetchContact();

  Future<List<ContactEntity>> fetchRecentContacts();
}
