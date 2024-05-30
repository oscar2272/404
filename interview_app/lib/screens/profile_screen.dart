import 'package:flutter/material.dart';
import 'package:interview_app/widgets/setting_quota_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showSettings = false;
  double _goalValue = 50.0;
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "지식/기술": 2,
      "태도": 1,
      "인성역량": 1,
      "개인배경": 1,
      "진정성": 1,
      "기타": 1,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 45, // 원의 반지름 설정
                foregroundColor: Colors.black,
                foregroundImage: AssetImage('assets/the1975.jpg'), // 이미지 경로 설정
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sim_77님",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "sim77@naver.com",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 40,
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
                const EdgeInsets.symmetric(
                  horizontal: 110,
                  vertical: 15,
                ),
              ),
            ),
            onPressed: () {},
            label: const Text(
              "프로필 편집",
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 65, 22, 22)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          PieChart(
            colorList: const [
              Color.fromARGB(235, 193, 191, 219),
              Color.fromARGB(236, 182, 142, 166),
              Color.fromARGB(239, 219, 234, 150),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(238, 43, 85, 114),
              Color.fromARGB(255, 169, 185, 236),
            ],
            gradientList: const [
              [
                Color.fromARGB(235, 193, 191, 219),
                Color.fromARGB(255, 170, 168, 196)
              ],
              [
                Color.fromARGB(236, 182, 142, 166),
                Color.fromARGB(255, 161, 120, 145)
              ],
              [
                Color.fromARGB(239, 219, 234, 150),
                Color.fromARGB(255, 198, 213, 128)
              ],
              [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 230, 230, 230)
              ],
              [
                Color.fromARGB(238, 43, 85, 114),
                Color.fromARGB(255, 20, 60, 90)
              ],
              [
                Color.fromARGB(255, 169, 185, 236),
                Color.fromARGB(255, 148, 165, 215)
              ],
            ],
            dataMap: dataMap,
            emptyColor: const Color.fromARGB(255, 0, 0, 0),
            animationDuration: const Duration(milliseconds: 400),
            initialAngleInDegree: -90,
            chartLegendSpacing: 50,
            chartRadius: MediaQuery.of(context).size.width / 2,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
          const SizedBox(
            height: 50,
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
                  height: 50,
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
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          '하루목표량 설정',
                          style: TextStyle(
                            fontSize: 18.0,
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
                        height: 101,
                        //margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 242, 243, 247),
                          border: Border(
                            bottom:
                                BorderSide(color: Color(0xFFE6E8F0), width: 1),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 11.5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 240,
                                  child: Text('내가 답변한 질문의 개수: 32개',
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                              ],
                            ),
                            Divider(
                              color: Color(0xFFE6E8F0),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Text('내가 선호하는 질문은 지식/기술입니다.',
                                    style: TextStyle(fontSize: 18.0)),
                              ],
                            ),
                            SizedBox(
                              height: 11.5,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
