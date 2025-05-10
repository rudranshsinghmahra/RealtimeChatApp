import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:realtime_chat_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:realtime_chat_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:realtime_chat_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:realtime_chat_app/views/chat_screen.dart';
import 'package:realtime_chat_app/views/login_screen.dart';
import 'package:realtime_chat_app/views/message_screen.dart';
import 'package:realtime_chat_app/views/register_screen.dart';

void main() {
  final authRepositoryImplementation = AuthRepositoryImplementation(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  runApp(MyApp(authRepositoryImplementation: authRepositoryImplementation));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImplementation authRepositoryImplementation;

  const MyApp({super.key, required this.authRepositoryImplementation});

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
      ],
      child: MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => RegisterScreen(),
          '/chatScreen': (_) => ChatScreen(),
        },
      ),
    );
  }
}
