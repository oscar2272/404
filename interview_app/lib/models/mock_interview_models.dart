class MockInterviewModels {
  final int mockInterviewAnswerId;
  final int logMockInterviewId;
  final int questionNum;
  final int questionId;
  final String questionTitle;
  final String answer;
  final String feedback;

  MockInterviewModels.fromJson(Map<String, dynamic> json)
      : mockInterviewAnswerId = json['mock_interview_answer_id'],
        logMockInterviewId = json['log_mock_interview_id'],
        questionNum = json['question_num'] ?? 0,
        questionId = json['question_id'] ?? 0,
        questionTitle = json['question_title'] ?? '',
        answer = json['answer'] ?? '',
        feedback = json['feedback'] ?? '';
}
