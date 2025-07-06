import 'package:realtime_chat_app/features/chat/domain/entity/daily_question_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/repositories/message_repository.dart';

class FetchDailyQuestionUseCase {
  final MessageRepository messageRepository;

  FetchDailyQuestionUseCase({required this.messageRepository});

  Future<DailyQuestionEntity> call(String conversationId) async {
    return await messageRepository.fetchDailyQuestion(conversationId);
  }
}
