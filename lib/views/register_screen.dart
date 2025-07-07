import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:realtime_chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:realtime_chat_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:realtime_chat_app/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:realtime_chat_app/features/auth/presentation/widgets/login_prompt.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onRegister() {
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffdecc9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInputField(
                hint: 'Username',
                icon: Icons.person,
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              AuthInputField(
                hint: 'Email',
                icon: Icons.mail,
                controller: _emailController,
              ),
              SizedBox(height: 20),
              AuthInputField(
                hint: 'Password',
                icon: Icons.password,
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(text: "Register", onPressed: _onRegister);
                },
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                    Navigator.pushNamed(context, '/login');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
              ),
              SizedBox(height: 20),
              LoginPrompt(
                title: "Already have an account? ",
                subTitle: "Click here to login",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
