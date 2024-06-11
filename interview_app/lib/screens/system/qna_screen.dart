import 'package:flutter/material.dart';

class QnaScreen extends StatelessWidget {
  const QnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 70 / 932,
            left: width * 50 / 430,
            right: width * 50 / 430,
            bottom: height * 50 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Contact Us",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: width * 24 / 430,
              ),
            ),
            SizedBox(
              height: height * 20 / 932,
            ),
            Text(
              "서비스 관련 문의 및 개선사항은 아래 이메일로 문의하세요.",
              overflow: TextOverflow.clip,
              style: TextStyle(fontSize: width * 15 / 430),
            ),
            SizedBox(
              height: height * 30 / 932,
            ),
            Row(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    Icons.email,
                    size: width * 28 / 430,
                  ),
                ),
                SizedBox(
                  width: width * 30 / 430,
                ),
                const Text("oscar2272@naver.com"),
              ],
            ),
            SizedBox(
              height: height * 40 / 932,
            ),
            Row(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    Icons.phone,
                    size: width * 28 / 430,
                  ),
                ),
                SizedBox(
                  width: width * 30 / 430,
                ),
                const Text("+082-2940-7777")
              ],
            ),
            SizedBox(
              height: height * 40 / 932,
            ),
            Row(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    Icons.location_on,
                    size: width * 28 / 430,
                  ),
                ),
                SizedBox(
                  width: width * 30 / 430,
                ),
                const Text(
                  "Gangseo-gu, Seoul, South Korea",
                  overflow: TextOverflow.clip,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
