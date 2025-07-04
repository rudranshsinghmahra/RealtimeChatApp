import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:realtime_chat_app/features/chat/data/models/message_models.dart';
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
}
