import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interview_app/provider/user_provider.dart';
import 'package:interview_app/screens/main/root_screen.dart';
import 'package:interview_app/screens/system/find_id_screen.dart';
import 'package:interview_app/screens/system/find_password_screen.dart';
import 'package:interview_app/screens/system/signup_screen.dart';
import 'package:interview_app/screens/popup_screen.dart';
import 'package:interview_app/validator/check_validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserProvider userState;

  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool isAutoLogin = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // 로딩 상태 변수 추가

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserProvider>(context, listen: false);
    _checkAutoLogin();
  }

  void onChanged(bool? newValue) {
    setState(() {
      isAutoLogin = newValue ?? false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true; // 로그인 시작 시 로딩 상태를 true로 설정
    });

    bool success = await userState.logIn(email, password);
    const prefs = FlutterSecureStorage();
    String? sessionId = await prefs.read(key: 'session_id');
    String? storedValue = await _storage.read(key: 'isPopup');

    if (!mounted) return;

    setState(() {
      _isLoading = false; // 로그인 후 로딩 상태를 false로 설정
    });

    if (success) {
      if (storedValue == "true") {
        if (isAutoLogin) {
          await _storage.write(key: 'auto_login', value: sessionId);
        }
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const RootScreen(),
          ),
          (route) => false,
        );
      } else {
        if (isAutoLogin) {
          await _storage.write(key: 'auto_login', value: sessionId);
        }
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PopupScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 또는 비밀번호가 일치하지 않습니다.')),
      );
    }
  }

  Future<void> _checkAutoLogin() async {
    String? autologin = await _storage.read(key: 'auto_login');
    String? storedValue = await _storage.read(key: 'isPopup');
    if (autologin != null) {
      if (storedValue == "true") {
        userState.fetchUserData();
        bool success = await userState.logInWithSession(autologin);

        if (success && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const RootScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        userState.fetchUserData();
        bool success = await userState.logInWithSession(autologin);

        if (success && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const PopupScreen(),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFf2f3f8),
      body: Padding(
        padding: EdgeInsets.only(
          top: height * 100 / 932,
          left: width * 60 / 430,
          right: width * 60 / 430,
          bottom: width * 50 / 932,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 10 / 932,
            ),
            Center(
              child: Image.asset(
                "assets/view.png",
                width: width * 200 / 430,
                height: height * 200 / 932,
              ),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
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
              height: height * 60 / 932,
              child: TextFormField(
                maxLength: 20,
                focusNode: _emailFocusNode,
                controller: _emailController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                validator: (value) =>
                    CheckValidate().validateEmail(_emailFocusNode, value!),
              ),
            ),
            SizedBox(
              height: height * 10 / 932,
            ),
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
              height: height * 60 / 932,
              child: TextFormField(
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
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: (value) => CheckValidate()
                    .validatePassword(_passwordFocusNode, value!),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isAutoLogin = !isAutoLogin;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Colors.blue,
                    value: isAutoLogin,
                    onChanged: (newValue) {
                      setState(() {
                        isAutoLogin = newValue!;
                      });
                    },
                    shape: const CircleBorder(),
                  ),
                  Text(
                    '자동 로그인',
                    style: TextStyle(
                      fontFamily: "NotoSansKR",
                      fontSize: width * 14 / 430,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 105, 7, 7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 30 / 932,
            ),
            Center(
              child: _isLoading // 로딩 상태에 따라 인디케이터 또는 버튼 표시
                  ? const CircularProgressIndicator() // 로딩 중인 경우 인디케이터 표시
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: const WidgetStatePropertyAll(
                            Color.fromARGB(255, 0, 0, 0)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(250, 50)),
                      ),
                      onPressed: _login,
                      child: Text(
                        "로그인",
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 18 / 430),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindIdScreen(),
                      ),
                    );
                  },
                  style: const ButtonStyle(),
                  child: Text(
                    "아이디 찾기",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: width * 12 / 430,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: height * 13 / 932,
                  width: width * 0.5 / 430,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindPasswordScreen(),
                      ),
                    );
                  },
                  style: const ButtonStyle(),
                  child: Text(
                    "비밀번호 찾기",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: width * 12 / 430,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: height * 13 / 932,
                  width: width * 0.5 / 430,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  style: const ButtonStyle(),
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: width * 12 / 430,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
