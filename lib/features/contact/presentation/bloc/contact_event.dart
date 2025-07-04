abstract class ContactsEvent {}

class FetchContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {
  final String email;

  AddContact({required this.email});
}

class CheckOrCreateConversation extends ContactsEvent {
  final String contactId;
  final String contactName;

  CheckOrCreateConversation(this.contactId, this.contactName);
}
