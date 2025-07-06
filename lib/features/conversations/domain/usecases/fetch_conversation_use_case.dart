import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';
import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';

class FetchConversationUseCase {
  final ConversationRepository repository;

  FetchConversationUseCase({required this.repository});

  Future<List<ConversationEntity>> call() async {
    return repository.fetchConversation();
  }
}
