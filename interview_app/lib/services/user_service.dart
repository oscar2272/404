import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interview_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String user = 'user';

  static Future<String?> findUserByNickname(String nickname) async {
    final url = Uri.parse('$baseUrl/$user/find_email/'); // URL 수정
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
        'nickname': nickname, // 사용자가 입력한 닉네임을 전달
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody['user'] != null) {
        User user = User.fromJson(responseBody['user']);
        return user.email; // 이메일만 반환
      } else {
        return null; // 사용자 없음
      }
    } else {
      return null; // 요청 실패
    }
  }

  static Future<bool?> changePassword(
      String password, String newPassword) async {
    final url = Uri.parse('$baseUrl/$user/reset_password/'); // URL 수정
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
        'password': password,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // 비밀번호 변경 성공시
      return true;
    } else {
      // 비밀번호 변경 실패
      return false;
    }
  }

  static Future<void> requestResetPassword(
      BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/$user/request_reset_password/'); // URL 수정
    final csrfToken = await _fetchCSRFTokenFromServer();
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode(
          {"email": email},
        ));
    if (!context.mounted) return;
    if (response.statusCode == 200) {
      // 성공적으로 비밀번호 재설정 이메일이 발송됨
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호 재설정 이메일이 발송되었습니다.')));
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')));
    }
  }

  static Future<String> _fetchCSRFTokenFromServer() async {
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
}
