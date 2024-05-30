import 'package:flutter/material.dart';
import 'package:interview_app/screens/root_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  bool isAutoLogin = false;
  bool _obscurePassword = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFf2f3f8),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 100, left: 60, right: 60, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.asset(
                "assets/view.png",
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                'Email',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                maxLength: 20,
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  fillColor: Colors.white, // Color(0xFFf5f5f5),
                  filled: true,
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // 이메일 형식 유효성 검사
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Opacity(
              opacity: 0.75,
              child: SelectableText(
                'password',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
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
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
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
                    value: isAutoLogin,
                    onChanged: (newValue) {
                      setState(() {
                        isAutoLogin = newValue!;
                      });
                    },
                    shape: const CircleBorder(), // 원형 체크박스
                  ),
                  const Text(
                    '자동 로그인',
                    style: TextStyle(
                      fontFamily: "NotoSansKR",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 105, 7, 7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // 모서리 둥근 정도 설정
                      ),
                    ),
                    backgroundColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 0, 0, 0)),
                    minimumSize: MaterialStateProperty.all(
                      const Size(250, 50),
                    )),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RootScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  "로그인",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Text(
                    "아이디 찾기",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: 13,
                  width: 0.5,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Text(
                    "비밀번호 찾기",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: 13,
                  width: 0.5,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
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
