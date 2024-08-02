import 'package:flutter/material.dart';
import 'package:interview_app/screens/system/chage_password_screen.dart';
import 'package:interview_app/validator/check_validator.dart';

class FindPasswordScreen extends StatelessWidget {
  const FindPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final emailFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: const Text("비밀번호 찾기"),
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
              height: height * 40 / 932,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
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
                    "비밀번호 찾기",
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
