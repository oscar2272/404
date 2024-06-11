import 'package:flutter/material.dart';

class CheckValidate {
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  String? validateNickname(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '닉네임을 입력하세요.';
    } else if (value.length < 5 || value.length > 15) {
      focusNode.requestFocus();
      return '닉네임은 5자 이상 15자 이하로 입력해주세요.';
    } else {
      // 정규식을 사용하여 한글, 영어, 숫자만 허용
      RegExp regExp = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]*$');
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '닉네임은 한글, 영어, 숫자만 입력 가능합니다.';
      } else {
        return null;
      }
    }
  }

  String? confirmPasswordValidator(FocusNode focusNode, String? confirmPw) {
    if (confirmPw == null || confirmPw.isEmpty) {
      return '비밀번호를 다시 입력해주세요.';
    }
    if (confirmPw != focusNode.toString()) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }
}
