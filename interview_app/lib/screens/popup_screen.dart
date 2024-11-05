import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interview_app/screens/main/root_screen.dart';

class PopupScreen extends StatefulWidget {
  const PopupScreen({super.key});

  @override
  State<PopupScreen> createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {
  late bool isPopup = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _loadPopupState() async {
    String? storedValue = await _storage.read(key: 'isPopup');
    if (storedValue != null) {
      setState(() {
        isPopup = storedValue == 'true';
      });
    }
  }

  Future<void> _savePopupState() async {
    if (isPopup == true) {
      await _storage.write(key: 'isPopup', value: 'true');
    } else {
      await _storage.write(key: 'isPopup', value: 'false');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPopupState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFf2f3f8),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 100 / 932,
            left: width * 40 / 430,
            right: width * 40 / 430,
            bottom: height * 40 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/view.png",
                width: width * 200 / 430,
                height: height * 200 / 932,
              ),
            ),
            Text(
              "Notice",
              style: TextStyle(
                  fontSize: width * 17 / 430, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            const Text("404 애플리케이션은 개발자의 면접을 AI로 분석하여 사용자에게 실전 경험을 제공합니다."),
            SizedBox(
              height: height * 20 / 932,
            ),
            const Text("문제풀기 : 문제를 푸는형식으로 자신의 답변에대한 피드백을 자세하게 받을수있습니다."),
            SizedBox(
              height: height * 20 / 932,
            ),
            const Text("모의면접 : 실제 면접을 보는것처럼 6문제를 풀고 면접결과를 확인할 수 있습니다."),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isPopup = !isPopup;
                });
              },
              child: Row(
                children: [
                  const Spacer(),
                  Transform.translate(
                    offset: const Offset(0, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RootScreen(),
                          ),
                          (route) => false,
                        );
                        await _savePopupState(); // 상태 저장
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "닫기",
                        style: TextStyle(
                            fontSize: width * 18 / 430,
                            color: const Color.fromARGB(255, 116, 97, 152),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset((width * 20 / 432), (height * 10 / 932)),
                    child: SizedBox(
                      height: height * 25 / 932,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: const Color.fromARGB(255, 51, 105, 175),
                        checkColor: const Color.fromARGB(255, 232, 225, 225),
                        value: isPopup,
                        onChanged: (newValue) {
                          setState(() {
                            isPopup = !isPopup;
                          });
                        },
                        splashRadius: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 26, 38, 54),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset((width * 20 / 432), (height * 10 / 932)),
                    child: SizedBox(
                      height: height * 25 / 932,
                      child: Text(
                        textAlign: TextAlign.center,
                        '다시 보지 않기',
                        style: TextStyle(
                          fontFamily: "NotoSansKR",
                          fontSize: width * 14 / 430,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 105, 7, 7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
