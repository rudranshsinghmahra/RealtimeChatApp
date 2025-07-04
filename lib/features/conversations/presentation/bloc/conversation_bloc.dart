import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/fetch_conversation_use_case.dart';


import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationUseCase fetchConversationsUseCase;

  ConversationBloc({required this.fetchConversationsUseCase})
    : super(ConversationInitial()) {
    on<FetchConversation>(_onFetchConversation);
  }

  Future<void> _onFetchConversation(
    FetchConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    try {
      final conversations = await fetchConversationsUseCase();
      emit(ConversationLoaded(conversations));
    } catch (e) {
      emit(ConversationError("Failed to load conversations $e"));
    }
  }
}
