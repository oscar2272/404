import 'package:flutter/material.dart';
import 'package:interview_app/screens/main/root_screen.dart';
import 'package:interview_app/validator/check_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _passwordFocusNode = FocusNode();
  final _passwordCorrectFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final nicknameFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureCorrectPassword = true;

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
                  FocusScope.of(context).requestFocus(emailFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 60 / 932,
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 20,
                  focusNode: emailFocusNode,
                  decoration: const InputDecoration(
                    fillColor: Colors.white, // Color(0xFFf5f5f5),
                    filled: true,
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) =>
                      CheckValidate().validateEmail(emailFocusNode, value!)),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
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
                  FocusScope.of(context).requestFocus(nicknameFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 60 / 932,
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 20,
                  focusNode: nicknameFocusNode,
                  decoration: const InputDecoration(
                    fillColor: Colors.white, // Color(0xFFf5f5f5),
                    filled: true,
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) => CheckValidate()
                      .validateNickname(nicknameFocusNode, value!)),
            ),
            SizedBox(
              height: height * 20 / 932,
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
                ),
                validator: (value) => CheckValidate()
                    .validatePassword(_passwordFocusNode, value!),
              ),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
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
                      .requestFocus(_passwordCorrectFocusNode);
                },
              ),
            ),
            SizedBox(
              height: height * 60 / 932,
              child: TextFormField(
                obscureText: _obscureCorrectPassword,
                maxLength: 20,
                focusNode: _passwordCorrectFocusNode,
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
                ),
                validator: (value) => CheckValidate()
                    .confirmPasswordValidator(_passwordFocusNode, value!),
              ),
            ),
            SizedBox(
              height: height * 40 / 932,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RootScreen(),
                    ),
                    (route) => false,
                  );
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
                    "회원가입",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 17 / 430),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 60 / 932,
            ),
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
