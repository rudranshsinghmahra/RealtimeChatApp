import 'package:realtime_chat_app/features/chat/domain/entity/daily_question_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<MessageEntity> messages;

  ChatLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String message;

  ChatErrorState(this.message);
}

class ChatDailyQuestionLoadedState extends ChatState {
  final DailyQuestionEntity dailyQuestion;

  ChatDailyQuestionLoadedState(this.dailyQuestion);
}
