import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/core/socket_services.dart';
import 'package:realtime_chat_app/di_container.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:realtime_chat_app/views/conversation_screen.dart';
import 'package:realtime_chat_app/views/login_screen.dart';
import 'package:realtime_chat_app/views/register_screen.dart';

import 'features/conversations/presentation/bloc/conversation_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final socketServices = SocketServices();
  await socketServices.initSocket();

  //Setting up getId;
  setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                registerUseCase: sl(),
                loginUseCase: sl(),
              ),
        ),
        BlocProvider(
          create:
              (_) => ConversationBloc(
                fetchConversationsUseCase: sl(),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChatBloc(
                fetchMessageUseCase: sl(),
                fetchDailyQuestionUseCase: sl(),
              ),
        ),
        BlocProvider(
          create:
              (_) => ContactsBloc(
                fetchContactUseCases: sl(),
                addContactUseCase: sl(),
                checkOrCreateConversationUseCase:
                sl(),
                fetchRecentContactUseCase: sl(),
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
