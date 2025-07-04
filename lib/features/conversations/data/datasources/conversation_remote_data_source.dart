import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat_app/features/conversations/data/models/conversation_model.dart';

class ConversationRemoteDataSource {
  final String baseUrl = 'http://192.168.1.35:4002';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversation() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch Conversations");
    }
  }

  Future<String> checkOrCreateConversations({required String contactId}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/check-or-create'),
      body: jsonEncode({"contactId": contactId}),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['conversationId'];
    } else {
      throw Exception("Failed to fetch Conversations");
    }
  }
}
