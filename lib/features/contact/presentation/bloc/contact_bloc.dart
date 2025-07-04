import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/add_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/fetch_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_event.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/check_or_create_conversations_usecase.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final FetchContactUseCases fetchContactUseCases;
  final AddContactUseCase addContactUseCase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;

  ContactsBloc({
    required this.fetchContactUseCases,
    required this.addContactUseCase,
    required this.checkOrCreateConversationUseCase,
  }) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContacts);
    on<CheckOrCreateConversation>(_onCheckOrCreateConversations);
  }

  FutureOr<void> _onFetchContacts(
    FetchContacts event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final contacts = await fetchContactUseCases();
      emit(ContactsLoaded(contacts));
    } catch (error) {
      emit(ContactsError("Failed to fetch contacts"));
    }
  }

  FutureOr<void> _onAddContacts(
    AddContact event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      await addContactUseCase(email: event.email);
      emit(ContactAdded());
      add(FetchContacts());
    } catch (error) {
      emit(ContactsError("Failed to fetch contacts"));
    }
  }

  FutureOr<void> _onCheckOrCreateConversations(
    CheckOrCreateConversation event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(ContactsLoading());
      final conversationId = await checkOrCreateConversationUseCase(
        contactId: event.contactId,
      );
      emit(
        ConversationReady(
          conversationId: conversationId,
          contactName: event.contactName,
        ),
      );
    } catch (error) {
      emit(ContactsError("Failed to start conversations $error"));
    }
  }
}
