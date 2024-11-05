class LogMockModels {
  final int logMockInterviewId;
  final DateTime submitAt;
  final int round;

  final int relevance;
  final int clarity;
  final int depth;
  final int logic;
  final int awareness;
  late final int? totalScore;
  LogMockModels.fromJson(Map<String, dynamic> json)
      : logMockInterviewId = json['log_mock_interview_id'],
        submitAt = DateTime.parse(json['submit_at']),
        round = json['round'],
        relevance = json['relevance'] ?? 0,
        clarity = json['clarity'] ?? 0,
        depth = json['depth'] ?? 0,
        logic = json['logic'] ?? 0,
        awareness = json['awareness'] ?? 0 {
    totalScore = relevance + clarity + depth + logic + awareness;
  }
}
