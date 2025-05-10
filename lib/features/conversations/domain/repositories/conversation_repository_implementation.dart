import 'package:realtime_chat_app/features/conversations/data/datasources/conversation_remote_data_source.dart';
import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';
import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImplementation implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<List<ConversationEntity>> fetchConversation() async {
    return await remoteDataSource.fetchConversation();
  }
}
