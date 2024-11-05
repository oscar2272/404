import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:interview_app/models/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class QuestionService {
  //static const String baseUrl = 'http://10.0.2.2:8000';

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String question = "questions";

  Future<List<Question>> fetchQuestions(
      {required String category,
      required String subCategory,
      required String bookmark,
      required String answer,
      required BuildContext context,
      r}) async {
    final uri = Uri.parse(
      '$baseUrl/questions?category=$category&subCategory=$subCategory&bookmark=$bookmark&answer=$answer',
    );

    final userState = Provider.of<UserProvider>(context, listen: false);
    final sessionId = await userState.getSessionId();

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> questionsJson =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<Question> questions =
            questionsJson.map((json) => Question.fromJson(json)).toList();
        return questions;
      } else {
        return [];
        // 오류 발생 시 스트림에 에러를 추가합니다.
      }
    } catch (e) {
      return [];
      // 예외 발생 시 스트림에 에러를 추가합니다.
    }
  }
}
