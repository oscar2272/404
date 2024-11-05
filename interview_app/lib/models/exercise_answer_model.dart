class ExerciseAnswer {
  final int? exerciseAnswerId;
  final int userId;
  final int questionId;
  final String answer;
  final String answeredAt;
  final String feedback;
  final String feedbackImprovement;

  ExerciseAnswer.fromJson(Map<String, dynamic> json)
      : exerciseAnswerId = json['exercise_answer_id'],
        userId = int.tryParse(json['user'].toString()) ?? 0,
        questionId = json['question_id'],
        answer = json['answer'],
        answeredAt = json['answered_at'],
        feedback = json['feedback'],
        feedbackImprovement = json['feedback_improvement'];
}
