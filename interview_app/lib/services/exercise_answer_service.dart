import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/models/exercise_answer_model.dart';

class ExerciseAnswerService {
  //static const String baseUrl = 'http://10.0.2.2:8000';

  static const String baseUrl =
      "https://port-0-interview-m33x64mke9ccf7ca.sel4.cloudtype.app";

  static const exercise = "exerciseAnswer";
  static const question = 'questions';

  static Future<http.Response> sendMessageToServer(
    String message,
    int questionId,
  ) async {
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final url = Uri.parse('$baseUrl/$exercise/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
        'Authorization': 'Session $sessionId',
      },
      body: json.encode({
        'question_id': questionId,
        'user_answer': message,
      }),
    );

    return response;
  }

  static Future<ExerciseAnswer> getAnswer(
      int? exerciseAnswerId, int questionId) async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final url = Uri.parse('$baseUrl/$exercise/$exerciseAnswerId/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Session $sessionId',
      },
    );
    if (response.statusCode == 200) {
      // JSON 응답을 파싱
      final answerJson = jsonDecode(utf8.decode(response.bodyBytes));
      return ExerciseAnswer.fromJson(answerJson);
    } else {
      // 오류 처리: 서버가 오류를 반환했을 때
      throw Exception('Failed to load ExerciseAnswer');
    }
  }

  static Future<String> removeAnswer(int exerciseAnswerId) async {
    final csrfToken = await _fetchCSRFTokenFromServer();
    final uri = Uri.parse('$baseUrl/$exercise/$exerciseAnswerId/');
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };
    final response = await http.delete(
      headers: headers,
      uri,
    );

    if (response.statusCode == 200) {
      return 'success';
    } else {
      return 'failed';
    }
  }

  static Future<int> answeredCount() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse('$baseUrl/$exercise/count/');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Session $sessionId',
      },
    );
    if (response.statusCode == 200) {
      final int count = json.decode(response.body)['answered_count'];
      return count;
    } else {
      throw Exception('Failed to fetch answered count');
    }
  }

  static Future<int> todayAnsweredCount() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse('$baseUrl/$exercise/todayCount/');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Session $sessionId',
      },
    );
    if (response.statusCode == 200) {
      final int count = json.decode(response.body)['answered_todayCount'];
      return count;
    } else {
      throw Exception('Failed to fetch answered count');
    }
  }

  static Future<String> mostAnsweredCategory() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse('$baseUrl/$exercise/category/');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Session $sessionId',
      },
    );
    if (response.statusCode == 200) {
      final String category = json.decode(response.body)['category'];
      return category;
    } else {
      throw Exception('Failed to fetch most answered category');
    }
  }

  static Future<String> _fetchCSRFTokenFromServer() async {
    // 서버에서 CSRF 토큰 가져오기
    final response = await http.get(Uri.parse('$baseUrl/get_csrf_token/'));

    // 응답 확인 및 CSRF 토큰 추출
    if (response.statusCode == 200) {
      // 서버 응답에서 CSRF 토큰을 추출
      final csrfToken = json.decode(response.body)['csrf_token'];
      return csrfToken;
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }
}
