class Question {
  final int questionId;
  final String category;
  final String subCategory;
  final String questionTitle;

  Question(
      {required this.questionId,
      required this.category,
      required this.subCategory,
      required this.questionTitle});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      category: json['category'],
      subCategory: json['sub_category'],
      questionTitle: json['question_title'],
    );
  }
}
