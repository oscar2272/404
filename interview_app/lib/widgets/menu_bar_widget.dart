import 'package:flutter/material.dart';
import 'package:interview_app/screens/system/qna_screen.dart';
import 'package:interview_app/screens/login_screen.dart';
import 'package:interview_app/screens/system/settings_screen.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
              backgroundColor: Colors.white,
            ),
            accountName: Text('OOO님'),
            accountEmail: Text('sim77@naver.com'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 97, 132),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey[850],
            ),
            title: const Text('Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const SettingScreen()),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer_outlined,
              color: Colors.grey[850],
            ),
            title: const Text('Q&A'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const QnaScreen()),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.grey[850],
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
