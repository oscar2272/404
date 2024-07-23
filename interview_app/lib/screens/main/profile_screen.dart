// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:interview_app/screens/system/edit_profile_screen.dart';
import 'package:interview_app/widgets/setting_quota_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<_ChartData> data;
  bool showSettings = false;
  double _goalValue = 50.0;
  final dataMap = <String, double>{
    "푼문제": 24,
  };
  final colorList = <Color>[
    const Color.fromARGB(255, 125, 166, 204),
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        padding: EdgeInsets.only(
            top: height * 40 / 932,
            left: width * 40 / 430,
            right: width * 40 / 430),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: width * 45 / 430, // 원의 반지름 설정
                  foregroundColor: Colors.black,
                  backgroundImage: const AssetImage('assets/the1975.jpg'),
                ),
                SizedBox(
                  width: width * 10 / 430,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sim_77님",
                      style: TextStyle(fontSize: width * 26 / 430),
                    ),
                    SizedBox(height: height * 7 / 932),
                    Text(
                      "sim77@naver.com",
                      style: TextStyle(fontSize: width * 15 / 430),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 40 / 932,
            ),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 6, 49, 49),
              ),
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 255, 255, 255),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder?>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                  EdgeInsets.symmetric(
                    horizontal: width * 110 / 430,
                    vertical: height * 15 / 932,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              label: Text(
                "프로필 편집",
                style: TextStyle(
                    fontSize: width * 16 / 430,
                    color: const Color.fromARGB(255, 65, 22, 22)),
              ),
            ),
            SizedBox(
              height: height * 30 / 932,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width * 25 / 430,
                    ),
                    Text(
                      "Quota",
                      style: TextStyle(
                        fontSize: width * 22 / 430,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: height * 30 / 932),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: width * 10 / 430),
                              height: height * 70 / 932,
                              width: width * 5 / 430,
                              decoration: BoxDecoration(
                                color: const Color(0xFF87A0E5).withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "하루 목표량",
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/flag.png",
                                    ),
                                    SizedBox(
                                      width: width * 57 / 430,
                                      child: const Text(
                                        "50문제",
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 20 / 932,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: width * 10 / 430),
                              height: height * 70 / 932,
                              width: width * 5 / 430,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF56E98).withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("오늘 푼 문제",
                                    textAlign: TextAlign.start),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/fire.png",
                                    ),
                                    SizedBox(
                                      width: width * 57 / 430,
                                      child: const Text(
                                        "24문제",
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 200 / 430,
                      height: height * 200 / 932,
                      child: PieChart(
                        dataMap: dataMap,
                        degreeOptions: const DegreeOptions(
                            totalDegrees: 360, initialAngle: 270),
                        animationDuration: const Duration(milliseconds: 2000),
                        chartType: ChartType.ring,
                        chartRadius: width * 130 / 430,
                        baseChartColor: const Color(0xFFe2e6ed),
                        emptyColor: Colors.blue,
                        colorList: colorList,
                        totalValue: 50.0, //
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: false,
                          showChartValues: false,
                        ),
                        legendOptions: const LegendOptions(showLegends: false),
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '목표량',
                              style: TextStyle(
                                  fontSize: width * 20 / 430,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '24/50',
                              style: TextStyle(
                                  fontSize: width * 20 / 430,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6161a1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 10 / 932,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showSettings = !showSettings;
                        });
                      },
                      child: Container(
                        height: height * 50 / 932,
                        decoration: BoxDecoration(
                          color: const Color(0xFFf2f3f8),
                          border: Border(
                            bottom: showSettings
                                ? const BorderSide(color: Color(0xFFf2f3f8))
                                : const BorderSide(color: Color(0xFFE6E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 12 / 430,
                            ),
                            Expanded(
                              child: Text(
                                '하루목표량 설정',
                                style: TextStyle(
                                  fontSize: width * 18.0 / 430,
                                ),
                              ),
                            ),
                            showSettings
                                ? const Icon(Icons.remove)
                                : const Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showSettings
                          ? SettingQuota(
                              goalValue: _goalValue,
                              onChanged: (newValue) {
                                setState(() {
                                  _goalValue = newValue;
                                });
                              },
                              onClose: () {
                                setState(() {
                                  showSettings = false;
                                });
                              },
                            )
                          : Container(
                              height: height * 105 / 932,
                              //margin: const EdgeInsets.only(top: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 242, 243, 247),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFE6E8F0), width: 1),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 11.5 / 932,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 12 / 430,
                                      ),
                                      SizedBox(
                                        width: width * 240 / 430,
                                        child: Text('내가 답변한 질문의 개수: 32개',
                                            style: TextStyle(
                                                fontSize: width * 18.0 / 430)),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Color(0xFFE6E8F0),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 12 / 430,
                                      ),
                                      Text('내가 선호하는 질문은 지식/기술입니다.',
                                          style: TextStyle(
                                              fontSize: width * 18.0 / 430)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 11.5 / 932,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);
  final Color color;
  final String x;
  final double y;
}
