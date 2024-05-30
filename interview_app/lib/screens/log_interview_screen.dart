import 'package:flutter/material.dart';

class LogInterviewScreen extends StatelessWidget {
  const LogInterviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 7,
                  offset: Offset(-3, 3),
                  color: Color.fromARGB(255, 242, 235, 235),
                ),
              ],
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 216, 219, 232),
                  Color.fromARGB(255, 219, 226, 234),
                  Color.fromARGB(255, 200, 210, 220),
                  Color.fromARGB(255, 180, 195, 210),
                ],
                // begin: Alignment.centerLeft,
                // end: Alignment.centerRight,
                // stops: [0.0, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.1, // Set the desired opacity here
                  child: Image.asset(
                    "assets/ddd.png",
                    width: 130,
                    height: 130,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 124, 142, 177),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "새 면접 ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 124, 142, 177),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "이어서 하기",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                // const Text(
                //   "90",
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                // ),
                // Text(
                //   "90",
                //   style: TextStyle(
                //       color: const Color.fromARGB(255, 69, 108, 140)
                //           .withOpacity(0.7),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
