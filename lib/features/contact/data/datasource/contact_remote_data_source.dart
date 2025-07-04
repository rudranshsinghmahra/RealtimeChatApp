import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../models/contact_model.dart';

class ContactRemoteDataSource {
  final String baseUrl = 'http://192.168.1.35:4002';
  final _storage = FlutterSecureStorage();

  Future<List<ContactModel>> fetchContact() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await get(
      Uri.parse("$baseUrl/contacts"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body.toString());
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch Messages");
    }
  }

  Future<void> addContact({required String email}) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await post(
      Uri.parse('$baseUrl/contacts'),
      body: jsonEncode({'contactEmail': email}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 201) {
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception("Failed to add contact");
    }
  }
}
