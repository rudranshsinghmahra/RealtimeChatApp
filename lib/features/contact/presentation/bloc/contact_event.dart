import 'package:realtime_chat_app/features/contact/domain/entities/contact_entity.dart';

abstract class ContactsEvent {}

class FetchContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {
  final String email;

  AddContact({required this.email});
}

class CheckOrCreateConversation extends ContactsEvent {
  final String contactId;
  final ContactEntity contact;

  CheckOrCreateConversation(this.contactId, this.contact);
}

class LoadRecentContact extends ContactsEvent {}
