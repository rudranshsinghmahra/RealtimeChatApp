import 'package:realtime_chat_app/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/repositories/message_repository.dart';

class MessageRepositoryImplementation implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    throw UnimplementedError();
  }
}
