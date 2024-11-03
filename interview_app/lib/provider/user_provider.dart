import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  //static const String baseUrl = 'http://10.0.2.2:8000';
  static const String baseUrl = "http://127.0.0.1:8000";
  Future<String> signUp(String email, String nickname, String password) async {
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
    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201) {
      // 세션 ID를 서버 응답에서 가져오기 (예시로 'session_id'라는 키 사용)
      String? sessionId = responseBody['session_id'];

      notifyListeners();
      if (sessionId != null) {
        // 세션 ID를 SharedPreferences에 저장
        const prefs = FlutterSecureStorage();
        await prefs.write(key: 'session_id', value: sessionId);
        await prefs.write(key: 'auto_login', value: sessionId);
        await fetchUserData();
        final String message = responseBody['message'];

        return message;
      } else {
        final String error = responseBody['error'];
        return error; // 세션 ID가 없으면 실패 처리
      }
    } else {
      // 서버 응답이 200이 아닌 경우 실패 처리
      final String error = responseBody['error'];
      return error;
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
      String? newSessionId =
          responseBody['session_id']; //로그인시 생성된 백엔드 session_id

      const prefs = FlutterSecureStorage();
      String? existingSessionId =
          await prefs.read(key: 'session_id'); //기존 로컬에 저장되어있는 session_id

      if (existingSessionId != newSessionId) {
        // 로그아웃후 다시로그인했거나 , 다른아이디로 로그인했을시
        await prefs.delete(key: 'session_id');
      }

      // 새로운 세션 ID를 저장합니다.
      if (newSessionId != null) {
        await prefs.write(key: 'session_id', value: newSessionId);
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

  Future<bool> logInWithSession(String sessionId) async {
    final url = Uri.parse('$baseUrl/user/login_session/'); // API URL 수정 필요
    final csrfToken = await _fetchCSRFTokenFromServer();

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
    );
    if (response.statusCode == 200) {
      await fetchUserData();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/user/logout');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      const prefs = FlutterSecureStorage();
      await prefs.delete(key: 'session_id');
      await prefs.delete(key: 'auto_login');
      await prefs.delete(key: 'isPopup');
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      final url = Uri.parse('$baseUrl/user/data');
      const prefs = FlutterSecureStorage();
      String? sessionId = await prefs.read(key: 'session_id');
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
    final responseData = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseData);
    if (response.statusCode == 200) {
      await fetchUserData();
      notifyListeners();
      return "성공";
    } else if (response.statusCode == 400) {
      return jsonResponse['error'];
    } else {
      return "알 수 없는 이유로 실패했습니다.";
    }
  }

  Future<void> settingQuota(int quota) async {
    final url = Uri.parse('$baseUrl/user/quota/'); // URL 수정
    final csrfToken = await _fetchCSRFTokenFromServer();
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
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

  Future<String?> getSessionId() async {
    const storage = FlutterSecureStorage();
    String? sessionId = await storage.read(key: 'session_id');

    return sessionId;
  }
}
