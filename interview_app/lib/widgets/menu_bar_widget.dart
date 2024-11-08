import 'package:flutter/material.dart';
import 'package:interview_app/provider/user_provider.dart';
import 'package:interview_app/screens/system/qna_screen.dart';
import 'package:interview_app/screens/login_screen.dart';
import 'package:interview_app/screens/system/settings_screen.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late final UserProvider userState;

  static const String baseUrl =
      "https://port-0-interview-m33x64mke9ccf7ca.sel4.cloudtype.app";

  @override
  void initState() {
    super.initState();

    userState = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage('$baseUrl${userState.user!.imageUrl}'),
              backgroundColor: Colors.white,
            ),
            accountName: Text(userState.user!.nickname),
            accountEmail: Text(userState.user!.email),
            decoration: const BoxDecoration(
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
            onTap: () async {
              bool loggedOut = await userState.logout();
              if (loggedOut) {
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃 실패')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
