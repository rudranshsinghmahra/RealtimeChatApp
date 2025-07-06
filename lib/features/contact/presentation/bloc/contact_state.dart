import 'package:realtime_chat_app/features/contact/domain/entities/contact_entity.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);
}

class ContactAdded extends ContactsState {}

class ConversationReady extends ContactsState {
  final String conversationId;
  final ContactEntity contact;

  ConversationReady({required this.conversationId, required this.contact});
}

class RecentContactLoaded extends ContactsState {
  final List<ContactEntity> recentContacts;

  RecentContactLoaded(this.recentContacts);
}
