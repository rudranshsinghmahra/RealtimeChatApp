import 'package:realtime_chat_app/features/conversations/data/datasources/conversation_remote_data_source.dart';
import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';
import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImplementation implements ConversationRepository {
  final ConversationRemoteDataSource conversationRemoteDataSource;

  ConversationRepositoryImplementation({
    required this.conversationRemoteDataSource,
  });

  @override
  Future<List<ConversationEntity>> fetchConversation() async {
    return await conversationRemoteDataSource.fetchConversation();
  }

  @override
  Future<String> checkOrCreateConversations({required String contactId}) async {
    return await conversationRemoteDataSource.checkOrCreateConversations(
      contactId: contactId,
    );
  }
}
