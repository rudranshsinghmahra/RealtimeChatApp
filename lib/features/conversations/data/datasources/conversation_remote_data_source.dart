import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat_app/features/conversations/data/models/conversation_model.dart';

class ConversationRemoteDataSource {
  final String baseUrl = 'http://localhost:4002';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversation() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/conversation'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch Conversations");
    }
  }
}
