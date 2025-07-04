import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/core/socket_services.dart';
import 'package:realtime_chat_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:realtime_chat_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:realtime_chat_app/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:realtime_chat_app/features/chat/data/repositories/message_repository_implementation.dart';
import 'package:realtime_chat_app/features/chat/domain/usecases/fetchMessageUseCase.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:realtime_chat_app/features/contact/data/datasource/contact_remote_data_source.dart';
import 'package:realtime_chat_app/features/contact/data/repositories/contact_repository_implementation.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/add_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/domain/usecases/fetch_contact_usecase.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:realtime_chat_app/features/conversations/data/datasources/conversation_remote_data_source.dart';
import 'package:realtime_chat_app/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:realtime_chat_app/features/conversations/data/repositories/conversation_repository_implementation.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/check_or_create_conversations_usecase.dart';
import 'package:realtime_chat_app/features/conversations/domain/usecases/fetch_conversation_use_case.dart';
import 'package:realtime_chat_app/views/conversation_screen.dart';
import 'package:realtime_chat_app/views/chat_screen.dart';
import 'package:realtime_chat_app/views/login_screen.dart';
import 'package:realtime_chat_app/views/register_screen.dart';

import 'features/conversations/presentation/bloc/conversation_bloc.dart';

void main() async {
  final authRepositoryImplementation = AuthRepositoryImplementation(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  final conversationRepositoryImplementation =
      ConversationRepositoryImplementation(
        conversationRemoteDataSource: ConversationRemoteDataSource(),
      );
  final messageRepositoryImplementation = MessageRepositoryImplementation(
    remoteDataSource: MessageRemoteDataSource(),
  );
  final contactRepositoryImplementation = ContactRepositoryImplementation(
    remoteDataSource: ContactRemoteDataSource(),
  );
  runApp(
    MyApp(
      authRepositoryImplementation: authRepositoryImplementation,
      conversationRepositoryImplementation:
          conversationRepositoryImplementation,
      messageRepositoryImplementation: messageRepositoryImplementation,
      contactRepositoryImplementation: contactRepositoryImplementation,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImplementation authRepositoryImplementation;
  final ConversationRepositoryImplementation
  conversationRepositoryImplementation;
  final MessageRepositoryImplementation messageRepositoryImplementation;
  final ContactRepositoryImplementation contactRepositoryImplementation;

  const MyApp({
    super.key,
    required this.authRepositoryImplementation,
    required this.conversationRepositoryImplementation,
    required this.messageRepositoryImplementation,
    required this.contactRepositoryImplementation,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                registerUseCase: RegisterUseCase(authRepositoryImplementation),
                loginUseCase: LoginUseCase(authRepositoryImplementation),
              ),
        ),
        BlocProvider(
          create:
              (_) => ConversationBloc(
                fetchConversationsUseCase: FetchConversationUseCase(
                  conversationRepositoryImplementation,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChatBloc(
                FetchMessageUseCase(
                  messagesRepository: messageRepositoryImplementation,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => ContactsBloc(
                fetchContactUseCases: FetchContactUseCases(
                  contactRepository: contactRepositoryImplementation,
                ),
                addContactUseCase: AddContactUseCase(
                  contactRepository: contactRepositoryImplementation,
                ),
                checkOrCreateConversationUseCase:
                    CheckOrCreateConversationUseCase(
                      conversationRepository:
                          conversationRepositoryImplementation,
                    ),
              ),
        ),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => RegisterScreen(),
          '/conversation': (_) => ConversationScreen(),
        },
      ),
    );
  }
}
