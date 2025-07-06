abstract class ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  LoadMessagesEvent(this.conversationId);
}

class SendMessagesEvent extends ChatEvent {
  final String conversationId;
  final String content;

  SendMessagesEvent(this.conversationId, this.content);
}

class ReceiveMessagesEvent extends ChatEvent {
  final Map<String, dynamic> message;

  ReceiveMessagesEvent(this.message);
}

class LoadDailyQuestionEvent extends ChatEvent {
  final String conversationId;

  LoadDailyQuestionEvent({required this.conversationId});
}
