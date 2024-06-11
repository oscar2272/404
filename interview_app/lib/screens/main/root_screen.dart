import 'package:flutter/material.dart';
import 'package:interview_app/screens/main/home_screen.dart';
import 'package:interview_app/screens/main/interviewlist_screen.dart';
import 'package:interview_app/screens/main/log_interview_screen.dart';
import 'package:interview_app/screens/main/profile_screen.dart';
import 'package:interview_app/widgets/menu_bar_widget.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const InterviewListScreen(),
    const LogInterviewScreen(),
    const ProfileScreen(),
  ];
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 243, 247, 1),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 242, 243, 247),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              Icons.menu_rounded,
              color: const Color.fromARGB(255, 46, 34, 4),
              size: MediaQuery.of(context).size.width * 50 / 430,
            ),
          ),
        ),
      ),
      drawer: const Menu(),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(50.0),
          bottom: Radius.circular(50.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFfbfbfb),
          iconSize: MediaQuery.of(context).size.width * 33 / 430,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onTapItem,
          selectedItemColor: Colors.lightBlue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_sharp),
              label: "문제풀기",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_file_rename_outline_outlined),
              label: "모의면접",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "내 정보",
            ),
          ],
        ),
      ),
    );
  }
}
