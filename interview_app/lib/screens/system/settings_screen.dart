import 'package:flutter/material.dart';
import 'package:interview_app/screens/main/root_screen.dart';
import 'package:interview_app/screens/system/chage_password_screen.dart';
import 'package:interview_app/widgets/setting_tile_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      appBar: AppBar(
        title: const Text("설정"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: width * 20 / 430, vertical: height * 20 / 932),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFD8DAE5),
                  width: 1.0,
                ),
                left: BorderSide(
                  color: Color(0xFFD8DAE5),
                  width: 1.0,
                ),
                right: BorderSide(
                  color: Color(0xFFD8DAE5),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: [
                SettingTile(
                  title: "디스플레이",
                  route: MaterialPageRoute(
                    builder: (context) => const RootScreen(),
                  ),
                ),
                SettingTile(
                  title: "알림 설정",
                  route: MaterialPageRoute(
                    builder: (context) => const RootScreen(),
                  ),
                ),
                SettingTile(
                  title: "비밀번호 변경",
                  route: MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                ),
                SettingTile(
                  title: "회원 탈퇴",
                  route: MaterialPageRoute(
                    builder: (context) => const RootScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
