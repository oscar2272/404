class Question {
  final int questionId;
  final int? bookmarkId;
  final int? exerciseAnswerId;
  final String category;
  final String subCategory;
  final String questionTitle;

  Question(
      {required this.questionId,
      required this.category,
      required this.subCategory,
      required this.questionTitle,
      required this.bookmarkId,
      required this.exerciseAnswerId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'], //value = 3
      category: json['category'], //
      subCategory: json['sub_category'],
      questionTitle: json['question_title'],

      bookmarkId: json['bookmark_id'],
      exerciseAnswerId: json['exercise_answer_id'],
    );
  }
}
