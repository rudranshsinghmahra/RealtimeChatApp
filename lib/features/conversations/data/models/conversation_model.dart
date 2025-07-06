import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    required super.participantName,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.participantImage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversation_id'] ?? '',
      participantName: json['participant_name'] ?? 'Unknown',
      participantImage:
          json['participant_image'] ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
      lastMessage: json['last_message'] ?? '',
      lastMessageTime:
          DateTime.tryParse(json['last_message_time'] ?? '') ?? DateTime.now(),
    );
  }
}
