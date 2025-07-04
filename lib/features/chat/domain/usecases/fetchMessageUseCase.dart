import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/repositories/message_repository.dart';

class FetchMessageUseCase {
  final MessageRepository messagesRepository;

  FetchMessageUseCase({required this.messagesRepository});

  Future<List<MessageEntity>> call(String conversationId) async {
    return await messagesRepository.fetchMessages(conversationId);
  }
}
