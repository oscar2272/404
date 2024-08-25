import 'package:flutter/material.dart';
import 'package:interview_app/provider/user_provider.dart';
import 'package:interview_app/screens/main/root_screen.dart';
import 'package:interview_app/validator/check_validator.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final UserProvider userState;

  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _emailError;
  String? _nicknameError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserProvider>(context, listen: false);
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = CheckValidate().validateEmail(_emailFocusNode, value);
    });
  }

  void _validateNickname(String value) {
    setState(() {
      _nicknameError =
          CheckValidate().validateNickname(_nicknameFocusNode, value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError =
          CheckValidate().validatePassword(_passwordFocusNode, value);
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _confirmPasswordError = CheckValidate()
          .confirmPasswordValidator(value, _passwordController.text);
    });
  }

  void _submitForm() async {
    if (_emailError == null &&
        _nicknameError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      // Extract user input
      String email = _emailController.text.trim();
      String nickname = _nicknameController.text.trim();
      String password = _passwordController.text.trim();

      // Call the signup service
      bool isSuccess = await userState.signUp(email, nickname, password);
      if (!mounted) return;
      if (isSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const RootScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 100 / 932,
            left: width * 60 / 430,
            right: width * 60 / 430,
            bottom: height * 50 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '이메일',
                style: TextStyle(
                  fontSize: width * 16 / 430,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 70 / 932,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 20,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  counterText: "",
                  errorText: _emailError,
                  errorStyle: TextStyle(height: height * 0.1 / 932),
                ),
                onChanged: _validateEmail,
              ),
            ),
            SizedBox(height: height * 20 / 932),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '닉네임',
                style: TextStyle(
                  fontSize: width * 16 / 430,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_nicknameFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 70 / 932,
              child: TextField(
                controller: _nicknameController,
                maxLength: 20,
                focusNode: _nicknameFocusNode,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  counterText: "",
                  errorText: _nicknameError,
                  errorStyle: TextStyle(height: height * 0.1 / 932),
                ),
                onChanged: _validateNickname,
              ),
            ),
            SizedBox(height: height * 20 / 932),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '비밀번호',
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
              height: height * 85 / 932,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                maxLength: 20,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  fillColor: Colors.white,
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
                onChanged: _validatePassword,
              ),
            ),
            SizedBox(height: height * 10 / 932),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                '비밀번호 확인',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  FocusScope.of(context)
                      .requestFocus(_confirmPasswordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 70 / 932,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                maxLength: 20,
                focusNode: _confirmPasswordFocusNode,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  counterText: "",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  errorText: _confirmPasswordError,
                  errorStyle: TextStyle(height: height * 0.1 / 932),
                ),
                onChanged: _validateConfirmPassword,
              ),
            ),
            SizedBox(height: height * 40 / 932),
            Center(
              child: GestureDetector(
                onTap: _submitForm,
                child: Container(
                  alignment: Alignment.center,
                  width: width * 200 / 430,
                  height: height * 55 / 932,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.blue,
                  ),
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 17 / 430),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 60 / 932),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "혹시 이미 계정이 있으신가요?",
                  style: TextStyle(fontSize: width * 16 / 430),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(fontSize: width * 16 / 430),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
