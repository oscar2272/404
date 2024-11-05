import 'package:flutter/material.dart';
import 'package:interview_app/services/user_service.dart';
import 'package:interview_app/validator/check_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _passwordError;
  String? _oldPasswordError;
  String? _confirmPasswordError;

  bool _obscureOldPassword = true;
  bool _obscurePassword = true;
  bool _obscureCorrectPassword = true;
  void _validateConfirmPassword(String value) {
    setState(() {
      _confirmPasswordError = CheckValidate()
          .confirmPasswordValidator(value, _passwordController.text);
    });
  }

  void _validateOldPassword(String value, FocusNode focusNode) {
    setState(() {
      _oldPasswordError = CheckValidate().validatePassword(focusNode, value);
    });
  }

  void _validatePassword(String value, FocusNode focusNode) {
    setState(() {
      _passwordError = CheckValidate().validatePassword(focusNode, value);
      _validateConfirmPassword(_confirmPasswordController.text); // 추가됨
    });
  }

  // @override
  // initState() {
  //   super.initState();
  // }

  void _submit() async {
    if (_oldPasswordError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      // 입력값이 모두 유효할 때만 서버에 제출
      if (_oldPasswordController.text == _passwordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('기존 비밀번호와 새 비밀번호가 같습니다.')),
        );
        return;
      }
      bool success = await UserService.changePassword(
          _oldPasswordController.text, _passwordController.text);
      if (success) {
        if (!mounted) return;
        // 비밀번호 변경 성공 시 성공 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        // 비밀번호 변경 실패 시 에러 메시지 출력
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호 변경에 실패했습니다.')),
        );
      }
    } else {
      // 입력값이 유효하지 않을 때 에러 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력값을 다시 확인해주세요..')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("비밀번호 변경"),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 100 / 932,
            left: width * 60 / 430,
            right: width * 60 / 430,
            bottom: height * 0 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '기존 비밀번호',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: width * 16 / 430,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_oldPasswordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 80 / 932,
              child: TextField(
                  controller: _oldPasswordController,
                  obscureText: _obscureOldPassword,
                  maxLength: 20,
                  focusNode: _oldPasswordFocusNode,
                  decoration: InputDecoration(
                    fillColor: Colors.white, //const Color(0xFFf5f5f5),
                    filled: true,
                    border: const OutlineInputBorder(),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                    errorText: _oldPasswordError,
                    errorStyle: TextStyle(
                        height: height * 1 / 932, overflow: TextOverflow.clip),
                  ),
                  onChanged: (value) {
                    _validateOldPassword(value, _oldPasswordFocusNode);
                  }),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '새 비밀번호',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: width * 16 / 430,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 80 / 932,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                maxLength: 20,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  fillColor: Colors.white, //const Color(0xFFf5f5f5),
                  filled: true,
                  border: const OutlineInputBorder(),
                  counterText: "",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  errorText: _passwordError,
                  errorStyle: TextStyle(
                      height: height * 1 / 932, overflow: TextOverflow.fade),
                ),
                onChanged: (value) {
                  _validatePassword(value, _passwordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '비밀번호 확인',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: width * 16 / 430,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: 80,
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureCorrectPassword,
                maxLength: 20,
                focusNode: _confirmPasswordFocusNode,
                decoration: InputDecoration(
                    fillColor: Colors.white, //const Color(0xFFf5f5f5),
                    filled: true,
                    border: const OutlineInputBorder(),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCorrectPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCorrectPassword = !_obscureCorrectPassword;
                        });
                      },
                    ),
                    errorText: _confirmPasswordError),
                onChanged: _validateConfirmPassword,
              ),
            ),
            SizedBox(
              height: height * 40 / 932,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _submit();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: width * 200 / 430,
                  height: height * 55 / 932,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.blue,
                  ),
                  child: Text(
                    "비밀번호 변경",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 17 / 430),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
