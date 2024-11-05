import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interview_app/models/log_mock_models.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/models/mock_interview_models.dart';

class MockService {
  //static const String baseUrl = 'http://10.0.2.2:8000';

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const logmock = "logMockInterview";
  static const mock = 'mockInterviewAnswer';

  // 모의 면접 목록 불러오기 - 완료
  static Future<List<LogMockModels>> fetchLogMockInterview() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse(
      '$baseUrl/$logmock',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 200) {
        // JSON 디코딩 후 'interviews' 리스트 추출
        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> logMockJson = jsonResponse['interviews'];

        final List<LogMockModels> logMockInterview =
            logMockJson.map((json) => LogMockModels.fromJson(json)).toList();

        return logMockInterview;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //새 면접
  static Future<MockInterviewModels> startNewMockInterview() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse(
      '$baseUrl/$logmock/start/',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Session $sessionId',
        },
      );

      final mockJson = jsonDecode(utf8.decode(response.bodyBytes));
      final dynamic mock = mockJson['data'];

      final MockInterviewModels mockInterview =
          MockInterviewModels.fromJson(mock);
      return mockInterview;
    } catch (e) {
      return MockInterviewModels.fromJson({});
    }
  }

  static Future<Map<String, dynamic>> submitAnswer(
      String message, int logMockInterviewId) async {
    final uri = Uri.parse(
      '$baseUrl/$logmock/$logMockInterviewId/$mock/',
    );
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    try {
      final response = await http.post(
        uri,
        body: jsonEncode(
          {
            'user_answer': message,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['gpt_response'] != null) {
          return {'gpt_response': responseData['gpt_response']};
        } else if (responseData['data'] != null) {
          return responseData['data'];
        }
      }
      return {"message": "요청을 실패했습니다 다시 시작해주세요"};
    } catch (e) {
      return {"message": "요청을 실패했습니다 다시 시작해주세요"};
    }
  }

  // 모의면접 한개 불러오기
  static Future<List<MockInterviewModels>> fetchMockInterview(
      int logMockInterviewId) async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse(
      '$baseUrl/$logmock/$logMockInterviewId/$mock/',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Session $sessionId',
        },
      );

      // JSON 응답에서 'answers' 키의 값을 가져오기
      final Map<String, dynamic> mockJson =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> answersJson = mockJson['answers'];
      final List<MockInterviewModels> mockInterview = answersJson
          .map((json) => MockInterviewModels.fromJson(json))
          .toList();
      return mockInterview;
    } catch (e) {
      return [];
    }
  }

  //모의면접 한개 삭제
  static Future<bool> fetchDeleteMockInterview(int logMockInterviewId) async {
    final uri = Uri.parse(
      '$baseUrl/$logmock/$logMockInterviewId/$mock/',
    );
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 500) {
        return false;
      } else {
        return false; //알수없는 오류
      }
    } catch (e) {
      return false;
    }
  }

  // 다시하기 메서드
  static Future<bool> fetchDeleteUserMessage(int logMockInterviewId) async {
    final uri = Uri.parse(
      '$baseUrl/$logmock/$logMockInterviewId/$mock/retry/',
    );
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 500) {
        return false;
      } else {
        return false; //알수없는 오류
      }
    } catch (e) {
      return false;
    }
  }

  //기존 진행중인 면접 목록 불러오기 메서드(existing메서드 활용해서 리스트불러오기)
  static Future<List<LogMockModels>> fetchExistingLogMockInterview() async {
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse(
      '$baseUrl/$logmock/check/',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Session $sessionId',
        },
      );

      final Map<String, dynamic> mockJson =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> answersJson = mockJson['interviews'];
      final List<LogMockModels> mockInterview =
          answersJson.map((json) => LogMockModels.fromJson(json)).toList();
      return mockInterview;
    } catch (e) {
      return [];
    }
  }

  //면접 모두삭제 메서드
  static Future<bool> fetchDeleteAllMockInterview() async {
    final uri = Uri.parse(
      '$baseUrl/$logmock/',
    );
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Authorization': 'Session $sessionId',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to delete all mock interviews');
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
