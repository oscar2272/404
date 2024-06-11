// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:interview_app/screens/system/edit_profile_screen.dart';
import 'package:interview_app/widgets/setting_quota_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<_ChartData> data;
  late List<_ChartData> data2;
  late TooltipBehavior _tooltip;
  bool showSettings = false;
  double _goalValue = 50.0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final List<_ChartData> data = [
      _ChartData(
          '지식/기술', 35, const Color.fromARGB(235, 193, 191, 219)), // 지식/기술
      _ChartData('태도', 28, const Color.fromARGB(236, 182, 142, 166)), // 태도
      _ChartData('인성역량', 34, const Color.fromARGB(239, 219, 234, 150)), // 인성역량
      _ChartData('개인배경', 32, const Color.fromARGB(255, 255, 255, 255)), // 개인배경
      _ChartData('진정성', 40, const Color.fromARGB(238, 43, 85, 114)), // 진정성
      _ChartData(
        '기타',
        40,
        const Color.fromARGB(255, 169, 185, 236),
      ), // 진정성
    ];

    _tooltip = TooltipBehavior(enable: true);
    return Padding(
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
                foregroundImage:
                    const AssetImage('assets/the1975.jpg'), // 이미지 경로 설정
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
            height: height * 20 / 932,
          ),
          SizedBox(
            height: height * 270 / 932,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis:
                  const NumericAxis(minimum: 0, maximum: 100, interval: 20),
              tooltipBehavior: _tooltip,
              series: <CartesianSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'Gold',
                  color: const Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (_ChartData data, _) => data.color,
                )
              ],
            ),
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
                        height: height * 101 / 932,
                        //margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 242, 243, 247),
                          border: Border(
                            bottom:
                                BorderSide(color: Color(0xFFE6E8F0), width: 1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);
  final Color color;
  final String x;
  final double y;
}
