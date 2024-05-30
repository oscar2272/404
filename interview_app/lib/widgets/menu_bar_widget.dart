import 'package:flutter/material.dart';
import 'package:interview_app/screens/login_screen.dart';

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
              backgroundImage: AssetImage('assets/the1975.jpg'),
              backgroundColor: Colors.white,
            ),
            accountName: Text('OOO님'),
            accountEmail: Text('sim77@naver.com'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 97, 132),
              // borderRadius: const BorderRadius.only(
              //     bottomLeft: Radius.circular(40.0),
              //     bottomRight: Radius.circular(40.0)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey[850],
            ),
            title: const Text('Setting'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer_outlined,
              color: Colors.grey[850],
            ),
            title: const Text('Q&A'),
            onTap: () {},
          ),
          const Divider(
            // Divider 추가
            color: Colors.grey, // Divider의 색상 설정
            thickness: 1, // Divider의 두께 설정
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
