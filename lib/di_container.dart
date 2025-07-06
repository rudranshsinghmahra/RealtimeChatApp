import 'package:get_it/get_it.dart';
import 'package:realtime_chat_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:realtime_chat_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:realtime_chat_app/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:realtime_chat_app/features/chat/data/repositories/message_repository_implementation.dart';
import 'package:realtime_chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:realtime_chat_app/features/chat/domain/usecases/fetchMessageUseCase.dart';
import 'package:realtime_chat_app/features/chat/domain/usecases/fetch_daily_question_usecase.dart';
import 'package:realtime_chat_app/features/contact/data/datasource/contact_remote_data_source.dart';
import 'package:realtime_chat_app/features/contact/data/repositories/contact_repository_implementation.dart';
import 'package:realtime_chat_app/features/contact/domain/repositories/contact_repository.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/add_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/fetch_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/fetch_recent_contact_usecase.dart';
import 'package:realtime_chat_app/features/conversations/data/datasources/conversation_remote_data_source.dart';
import 'package:realtime_chat_app/features/conversations/data/repositories/conversation_repository_implementation.dart';
import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/check_or_create_conversations_usecase.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/fetch_conversation_use_case.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  const String baseUrl = "http://192.168.1.35:4002";

  //DATA SOURCES
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(baseUrl: baseUrl),
  );
  sl.registerLazySingleton<ConversationRemoteDataSource>(
    () => ConversationRemoteDataSource(baseUrl: baseUrl),
  );
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSource(baseUrl: baseUrl),
  );
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSource(baseUrl: baseUrl),
  );

  //REPOSITORIES

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(authRemoteDataSource: sl()),
  );
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImplementation(
      conversationRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImplementation(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImplementation(remoteDataSource: sl()),
  );

  //USE-CASES

  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchConversationUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchMessageUseCase(messagesRepository: sl()));
  sl.registerLazySingleton(
    () => FetchDailyQuestionUseCase(messageRepository: sl()),
  );
  sl.registerLazySingleton(() => FetchContactUseCases(contactRepository: sl()));
  sl.registerLazySingleton(() => AddContactUseCase(contactRepository: sl()));
  sl.registerLazySingleton(
    () => CheckOrCreateConversationUseCase(conversationRepository: sl()),
  );
  sl.registerLazySingleton(
    () => FetchRecentContactUseCase(contactRepository: sl()),
  );
}
