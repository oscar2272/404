import 'package:flutter/material.dart';
import 'package:interview_app/screens/system/find_id_result_screen.dart';
import 'package:interview_app/services/user_service.dart';
import 'package:interview_app/validator/check_validator.dart';

class FindIdScreen extends StatelessWidget {
  const FindIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final nicknameFocusNode = FocusNode();
    final nicknameController = TextEditingController();

    Future<void> findUserAndNavigate(
        BuildContext context, TextEditingController nicknameController) async {
      if (nicknameController.text.isNotEmpty) {
        // 닉네임이 입력된 경우 사용자 찾기 요청
        String? email =
            await UserService.findUserByNickname(nicknameController.text);

        if (email != null) {
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => FindIdResultScreen(
                email: email, // 이메일 결과를 넘깁니다.
              ),
            ),
          );
        } else {
          // 이메일 찾기에 실패한 경우 사용자에게 알림 표시
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('찾고 계시는 이메일이 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('닉네임을 입력해 주세요.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("아이디 찾기"),
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
                  controller: nicknameController,
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
              height: height * 40 / 932,
            ),
            Center(
              child: GestureDetector(
                onTap: () => findUserAndNavigate(context, nicknameController),
                child: Container(
                  alignment: Alignment.center,
                  width: width * 200 / 430,
                  height: height * 55 / 932,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.blue,
                  ),
                  child: Text(
                    "아이디 찾기",
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
