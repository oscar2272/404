import 'package:flutter/material.dart';
import 'package:interview_app/widgets/log_card_widget.dart';

class ResultInterviewScreen extends StatefulWidget {
  const ResultInterviewScreen({super.key});

  @override
  State<ResultInterviewScreen> createState() => _ResultInterviewScreenState();
}

class _ResultInterviewScreenState extends State<ResultInterviewScreen> {
  List<int> cardOrder = [0, 1, 2, 3, 4];
  List<Color> color = [
    const Color.fromARGB(235, 193, 191, 219), // 지식/기술
    const Color.fromARGB(235, 193, 191, 219), // 지식/기술
    const Color.fromARGB(236, 182, 142, 166), // 태도
    const Color.fromARGB(239, 219, 234, 150), // 인성역량
    const Color.fromARGB(238, 43, 85, 114), // 진정성
  ];
  List<String> feedback = [
    "지식/기술 에대한 평과 결과는",
    "지식/기술 에대한 평과 결과는",
    "태도 에대한 평과 결과는",
    "인성역량 에대한 평과 결과는",
    "진정성 에대한 평과 결과는",
  ];
  void changeCardOrder(int logCard, int index) {
    setState(() {
      Color materialAccentColor = color[index]; //현재인덱스 = index
      cardOrder.remove(logCard); // 현재 (card=logCard)를 제거
      color.removeAt(index); // 현재 인덱스의 해당하는 컬러하나 제거
      color.insert(0, materialAccentColor);
      cardOrder.insert(0, logCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 243, 247),
        leadingWidth: width * 200 / 430,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: width * 27 / 430,
              ),
            ),
            Text(
              "1회차 결과",
              style: TextStyle(fontSize: width * 17 / 430),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 40 / 430, vertical: height * 30 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "합격률 : 88%",
              style: TextStyle(
                fontSize: width * 20 / 430,
              ),
            ),
            SizedBox(
              height: height * 600 / 932,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < cardOrder.length; i++)
                    LogCard(
                      feedback: feedback[i],
                      color: color[i],
                      index: i,
                      key: ValueKey(cardOrder[i]),
                      value: cardOrder[i],
                      onDragged: () => changeCardOrder(cardOrder[i], i),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
