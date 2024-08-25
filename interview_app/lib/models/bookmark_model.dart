class Bookmark {
  final int bookmarkId;
  final int questionId;
  final int userId;

  Bookmark.fromJson(Map<String, dynamic> json)
      : bookmarkId = json['bookmark_id'],
        questionId = json['question_id'] ?? '',
        userId = json['user_id'] ?? '';
}
