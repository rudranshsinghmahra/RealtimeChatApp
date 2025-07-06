import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:realtime_chat_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  // final String baseUrl = "http://192.168.1.35:4002/auth";
  final String baseUrl;

  AuthRemoteDataSource({required this.baseUrl});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    print("This is response body ${response.body}");

    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print("This is response body ${response.body}");

    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }
}
