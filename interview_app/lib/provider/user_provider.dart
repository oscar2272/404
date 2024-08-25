import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  static const String baseUrl = "http://127.0.0.1:8000";
  Future<bool> signUp(String email, String nickname, String password) async {
    final url = Uri.parse('$baseUrl/user/signup/'); // API URL 수정 필요
    // CSRF 토큰 가져오기
    final csrfToken = await _fetchCSRFTokenFromServer();
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'email': email,
        'nickname': nickname,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      // 세션 ID를 서버 응답에서 가져오기 (예시로 'session_id'라는 키 사용)
      String? sessionId = responseBody['session_id'];

      notifyListeners();
      if (sessionId != null) {
        // 세션 ID를 SharedPreferences에 저장
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_id', sessionId);

        await fetchUserData();

        return true;
      } else {
        return false; // 세션 ID가 없으면 실패 처리
      }
    } else {
      // 서버 응답이 200이 아닌 경우 실패 처리
      return false;
    }
  }

  Future<bool> logIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/user/login/'); // API URL 수정 필요
    final csrfToken = await _fetchCSRFTokenFromServer();
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      String? newSessionId = responseBody['session_id'];

      // 현재 저장된 세션 ID를 가져옵니다.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingSessionId = prefs.getString('session_id');

      // 세션 ID가 다를 경우 기존 세션 ID를 제거합니다.
      if (existingSessionId != null && existingSessionId != newSessionId) {
        await prefs.remove('session_id');
      }

      // 새로운 세션 ID를 저장합니다.
      if (newSessionId != null) {
        await prefs.setString('session_id', newSessionId);
        await fetchUserData(); // 사용자 데이터 갱신
        notifyListeners();
        return true;
      } else {
        return false; // 세션 ID가 없으면 실패 처리
      }
    } else {
      return false; // 서버 응답이 200이 아닌 경우 실패 처리
    }
  }

  Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/user/logout');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_id');
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      final url = Uri.parse('$baseUrl/user/data');
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Session $sessionId'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        User user = User.fromJson(responseData);
        _user = user;
        notifyListeners();
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error fetching user data: $e');
      return; // 예외 발생 시 null 반환
    }
  }

  Future<String> updateProfile(
      String nickname, XFile? image, int userId) async {
    final url = Uri.parse('$baseUrl/user/$userId/'); // UR  L 수정
    String csrfToken = await _fetchCSRFTokenFromServer();
    final request = http.MultipartRequest('POST', url);
    request.fields['nickname'] = nickname;
    request.headers['X-CSRFToken'] = csrfToken;
    request.headers['cookie'] = 'csrftoken=$csrfToken';

    if (image != null) {
      final imageFile = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(imageFile);
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      await fetchUserData();
      notifyListeners();
      return "성공";
    } else if (response.statusCode == 400) {
      return "중복";
    } else {
      return "실패";
    }
  }

  Future<void> settingQuota(int quota) async {
    final url = Uri.parse('$baseUrl/user/quota/'); // URL 수정
    final csrfToken = await _fetchCSRFTokenFromServer();
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
      'Authorization': 'Session $sessionId',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'quota': quota,
      }),
    );

    if (response.statusCode == 200) {
      notifyListeners();
      // 성공적으로 할당량이 변경됨
    } else {
      // 오류 처리
    }
  }

  Future<void> resetImage(int userId) async {
    final url = Uri.parse('$baseUrl/user/$userId/image/');
    final csrfToken = await _fetchCSRFTokenFromServer();
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };
    final response = await http.put(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      await fetchUserData();
      notifyListeners();
    } else {
      // 오류 처리
    }
  }

  Future<String> _fetchCSRFTokenFromServer() async {
    // 서버에서 CSRF 토큰 가져오기
    final response = await http.get(Uri.parse('$baseUrl/get_csrf_token'));

    // 응답 확인 및 CSRF 토큰 추출
    if (response.statusCode == 200) {
      // 서버 응답에서 CSRF 토큰을 추출
      final csrfToken = json.decode(response.body)['csrf_token'];
      return csrfToken;
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    return sessionId;
  }
}
