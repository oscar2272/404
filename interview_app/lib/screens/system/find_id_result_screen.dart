import 'package:flutter/material.dart';

class FindIdResultScreen extends StatelessWidget {
  const FindIdResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 100 / 932,
            left: width * 60 / 430,
            right: width * 60 / 430,
            bottom: height * 50 / 932),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                    child: Text(
                  "사용자님의 아이디는 ",
                  style: TextStyle(
                    fontSize: width * 18 / 430,
                  ),
                )),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "oscar2272@naver.com",
                        style: TextStyle(
                            fontSize: width * 18 / 430,
                            color: const Color(0xFF305AAA)),
                      ),
                      Text(
                        "입니다.",
                        style: TextStyle(fontSize: width * 18 / 430),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 100 / 932,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                  alignment: Alignment.center,
                  width: width * 200 / 430,
                  height: height * 60 / 932,
                  decoration: BoxDecoration(
                      color: const Color(0xFF5e50fa),
                      borderRadius: BorderRadius.circular(7)),
                  child: Text(
                    "로그인 페이지",
                    style: TextStyle(
                        fontSize: width * 18 / 430,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ),
            SizedBox(
              width: width * 20 / 430,
            ),
          ],
        ),
      ),
    );
  }
}
