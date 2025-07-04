import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversation();

  Future<String> checkOrCreateConversations({required String contactId});
}
