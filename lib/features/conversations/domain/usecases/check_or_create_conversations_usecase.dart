import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository conversationRepository;

  CheckOrCreateConversationUseCase({required this.conversationRepository});

  Future<String> call({required String contactId}) async {
    return conversationRepository.checkOrCreateConversations(contactId: contactId);
  }
}
