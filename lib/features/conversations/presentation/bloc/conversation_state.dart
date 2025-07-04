import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';

abstract class ConversationState {}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;

  ConversationLoaded(this.conversations);
}

class ConversationError extends ConversationState {
  final String message;

  ConversationError(this.message);
}
