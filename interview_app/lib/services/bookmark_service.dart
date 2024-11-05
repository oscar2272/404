import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BookmarkService {
  //static const String baseUrl = 'http://10.0.2.2:8000';

  static const String baseUrl = "http://127.0.0.1:8000";
  static const String user = "user";
  static const String bookmark = "bookmarks";

  static Future<int> addBookmark(int questionId) async {
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final uri = Uri.parse('$baseUrl/$user/$bookmark/');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
        'Authorization': 'Session $sessionId',
      },
      body: jsonEncode({
        'question_id': questionId,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData['bookmark_id']; // 북마크 ID 반환
    } else {
      throw Exception('Failed to add bookmark');
    }
  }

  static Future<void> removeBookmark(int bookmarkId) async {
    final uri = Uri.parse('$baseUrl/$user/$bookmark/$bookmarkId/');
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    final response = await http.delete(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Session $sessionId'
      },
      uri,
    );

    if (response.statusCode == 200) {
    } else {}
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
