import 'package:flutter/material.dart';
import 'package:interview_app/screens/interview/result_interview_screen.dart';

class LogInterviewScreen extends StatefulWidget {
  const LogInterviewScreen({super.key});

  @override
  State<LogInterviewScreen> createState() => _LogInterviewScreenState();
}

class _LogInterviewScreenState extends State<LogInterviewScreen> {
  void _deleteAllRecords() {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 20 / 430, vertical: height * 30 / 932),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: height * 210 / 932,
            width: width * 350 / 430,
            padding: EdgeInsets.symmetric(horizontal: width * 10 / 430),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset:
                      Offset(0, height * 3 / 932), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 157, 187, 249),
                  Color.fromARGB(255, 160, 188, 243),
                  Color.fromARGB(255, 156, 185, 241),
                  Color.fromARGB(255, 153, 179, 230),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Transform.scale(
                          scale: 3.3,
                          child: Transform.translate(
                            offset: Offset(width * 10 / 430, height * 5 / 932),
                            child: Opacity(
                              opacity: 0.5, // Set the desired opacity here
                              child: Image.asset(
                                "assets/4.png",
                                width: width * 150 / 430,
                                height: height * 60 / 932,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 100 / 430,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 10 / 430,
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_horiz_outlined),
                                  iconSize: width * 35 / 430,
                                  iconColor: Colors.white,
                                  onSelected: (String value) {
                                    if (value == 'delete_all') {
                                      _deleteAllRecords();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'close',
                                        child: Center(
                                            child: Text('닫기',
                                                style: TextStyle(
                                                    fontSize:
                                                        width * 15 / 430))),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete_all',
                                        child: Center(
                                            child: Text(
                                          '기록 삭제',
                                          style: TextStyle(
                                              fontSize: width * 15 / 430),
                                        )),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 50 / 932,
                            ),
                            Text(
                              "90",
                              style: TextStyle(
                                  fontSize: width * 20 / 430,
                                  color: Colors.white),
                            ),
                            Text(
                              "AVERAGE",
                              style: TextStyle(
                                  fontSize: width * 16 / 430,
                                  color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 30 / 430,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          setState(() {});
                        },
                        child: SizedBox(
                          height: height * 40 / 932,
                          width: width * 108 / 430,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "이어서 하기",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 15 / 430,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.play_arrow,
                                color: const Color.fromARGB(255, 216, 221, 224),
                                size: width * 30 / 430,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 20 / 430,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          setState(() {});
                        },
                        child: SizedBox(
                          height: width * 40 / 430,
                          width: height * 95 / 932,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "새 면접 ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 15 / 430,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.playlist_play_rounded,
                                color: const Color.fromARGB(255, 216, 221, 224),
                                size: width * 30 / 430,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 10 / 932,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 30 / 430, vertical: height * 10 / 932),
              itemCount: 100,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: height * 90 / 932,
                  width: width * 400 / 430,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 55 / 932,
                        width: width * 55 / 430,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                1.0), // Adjust the value to change the roundness
                          ),
                          color: const Color(0xFF13548f),
                          child: Center(
                            child: Text(
                              '$index',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 17 / 430,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "회차",
                          style: TextStyle(
                            fontSize: width * 18 / 430,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 50 / 430,
                        child: Text(
                          "90 점",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 16 / 430,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) =>
                                  const ResultInterviewScreen()),
                            ),
                          );
                        },
                        //Icons.insert_drive_file_outlined,
                        iconSize: width * 30 / 430,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
