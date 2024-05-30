import 'package:flutter/material.dart';
import 'package:interview_app/widgets/log_container_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final dataMap = <String, double>{
    "푼문제": 24,
  };
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  final List<Color> logContainerColorList = const [
    Color.fromARGB(235, 193, 191, 219), // 지식/기술
    Color.fromARGB(236, 182, 142, 166), // 태도
    Color.fromARGB(239, 219, 234, 150), // 인성역량
    Color.fromARGB(255, 255, 255, 255), // 개인배경
    Color.fromARGB(238, 43, 85, 114), // 진정성
    Color.fromARGB(255, 169, 185, 236), // 기타
  ];
  final List<String> logContainerCategoryList = const [
    "지식/기술",
    "태도",
    "인성역량",
    "개인배경",
    "진정성",
    "기타",
  ];
  final List<Color> logContainerTextColor = const [
    Colors.white,
    Colors.white,
    Colors.black,
    Color.fromARGB(255, 65, 60, 60),
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                "Quota",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 70,
                        width: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF87A0E5).withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("하루 목표량"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/flag.png",
                              ),
                              const SizedBox(
                                width: 57,
                                child: Text(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 70,
                        width: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF56E98).withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("오늘 푼 문제"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/fire.png",
                              ),
                              const SizedBox(
                                width: 57,
                                child: Text(
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
                width: 200,
                height: 200,
                child: PieChart(
                  dataMap: dataMap,
                  degreeOptions:
                      const DegreeOptions(totalDegrees: 360, initialAngle: 270),
                  animationDuration: const Duration(milliseconds: 2000),
                  chartType: ChartType.ring,
                  chartRadius: 130,
                  baseChartColor: const Color(0xFFe2e6ed),
                  gradientList: const [
                    [
                      Color.fromARGB(255, 240, 160, 89),
                      Color.fromARGB(250, 230, 150, 80),
                      Color.fromARGB(245, 220, 140, 71),
                      Color.fromARGB(240, 210, 130, 62),
                    ],
                  ],
                  colorList: colorList,
                  totalValue: 50.0, //
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: false,
                    showChartValues: false,
                  ),
                  legendOptions: const LegendOptions(showLegends: false),
                  centerWidget: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '목표량',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '24/50',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6161a1)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          const Row(
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                "Log ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              SizedBox(
                height: 280,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: LogContainer(index,
                          color: logContainerColorList[index],
                          category: logContainerCategoryList[index],
                          textColor: logContainerTextColor[index]),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
