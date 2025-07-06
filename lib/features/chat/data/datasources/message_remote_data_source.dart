import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:realtime_chat_app/features/chat/data/models/daily_questions_model.dart';
import 'package:realtime_chat_app/features/chat/data/models/message_models.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/daily_question_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';

class MessageRemoteDataSource {
  final String baseUrl = "http://192.168.1.35:4002";
  final _storage = FlutterSecureStorage();

  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await get(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch messages");
    }
  }

  Future<DailyQuestionsModel> fetchDailyQuestions(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await get(
      Uri.parse('$baseUrl/conversations/$conversationId/daily-question'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return DailyQuestionsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch daily question");
    }
  }
}
