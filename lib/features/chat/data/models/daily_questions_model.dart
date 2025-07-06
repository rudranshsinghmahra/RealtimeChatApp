import 'package:realtime_chat_app/features/chat/domain/entity/daily_question_entity.dart';

class DailyQuestionsModel extends DailyQuestionEntity {
  DailyQuestionsModel({required super.content});

  factory DailyQuestionsModel.fromJson(Map<String, dynamic> json) {
    return DailyQuestionsModel(
      content: json['question'] ?? "No question available",
    );
  }
}
