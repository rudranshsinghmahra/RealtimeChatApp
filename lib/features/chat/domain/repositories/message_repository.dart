import 'package:realtime_chat_app/features/chat/domain/entity/daily_question_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';

abstract class MessageRepository{
  Future<List<MessageEntity>> fetchMessages(String conversationId);
  Future<void> sendMessage(MessageEntity message);

  Future<DailyQuestionEntity> fetchDailyQuestion(String conversationId);
}