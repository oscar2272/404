import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Route<Object?> route;
  final String title;
  const SettingTile({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: width * 40 / 430,
              top: height * 10 / 932,
              bottom: height * 10 / 932,
              right: width * 40 / 430),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFD8DAE5),
                width: 1.0,
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF101840), fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.push(
                context,
                route,
              );
            },
          ),
        ),
      ],
    );
  }
}
