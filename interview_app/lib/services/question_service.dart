import 'dart:convert';
import 'package:interview_app/models/question_model.dart';
import 'package:http/http.dart' as http;

class QuestionService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String question = "questions";

  Future<List<Question>> fetchQuestions(
      {required String category, required String subCategory}) async {
    List<Question> questionsInstance = [];
    final queryParameters = {
      'category': category,
      'subCategory': subCategory,
    };
    final uri = Uri.parse(
            '$baseUrl/$question?category=$category&subCategory=$subCategory')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> questions =
          jsonDecode(utf8.decode(response.bodyBytes));
      for (var question in questions) {
        questionsInstance.add(Question.fromJson(question));
      }
      return questionsInstance;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
