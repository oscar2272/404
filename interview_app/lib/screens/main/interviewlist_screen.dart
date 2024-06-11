import 'package:flutter/material.dart';
import 'package:interview_app/screens/interview/chat_interview_screen.dart';
import 'package:interview_app/widgets/custom_dropdown_widget.dart';

class InterviewListScreen extends StatefulWidget {
  const InterviewListScreen({super.key});

  @override
  State<InterviewListScreen> createState() => _InterviewListScreenState();
}

class _InterviewListScreenState extends State<InterviewListScreen> {
  int selectedUpperCategoryIndex = 0;
  late List<bool> checkbox;
  late List<bool> isMarkedList;
  //
  late List<bool> _selections;
  final List<String> upperCategories = [
    "지식/기술",
    "태도",
    "인성역량",
    "개인배경",
    "진정성",
    "기타"
  ];
  final List<List<String>> lowerCategories = [
    ["#프로그래밍", "#개발방법론", "#장애대응", "#기타"],
    ["#ICT 기술지향성", "#HW/SW 이해", "#정보보안", "#기타"],
    ["#도전정신", "#갈등관리", "#자기계발", "#협동성", "#기타"],
    ["#성격", "#가치관", "#개인사", "#기타"],
    ["#진정성(직무)", "#진정성(회사)", "#기타"],
    []
  ];
  final List<String> labelItems = ['Show All', 'Unsolved', 'Solved'];
  final List<String> bookmarkItems = ["Show All", "Not marked", "Bookmarked"];
  String? _selectLabel;
  String? _selectBookmark;
  String bookmark = "북마크";
  String solved = "문제";
  @override
  void initState() {
    super.initState();
    _selections = List.generate(
        lowerCategories[selectedUpperCategoryIndex].length, (index) => false);
    checkbox = List.generate(100, (index) => false);
    checkbox[0] = true;
    isMarkedList = List.generate(100, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 8.0 / 430, vertical: height * 8 / 932),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                upperCategories.length,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width * 8.0 / 430),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedUpperCategoryIndex = index;
                          _selections = List.generate(
                              lowerCategories[index].length, (index) => false);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 8 / 932,
                            horizontal: width * 16 / 430),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 242, 235, 235),
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(0, height * 3 / 932),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                          color: selectedUpperCategoryIndex == index
                              ? const Color.fromARGB(255, 133, 143, 162)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            upperCategories[index],
                            style: TextStyle(
                              fontSize: 15.5,
                              color: selectedUpperCategoryIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: selectedUpperCategoryIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: height * 60 / 932,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: lowerCategories[selectedUpperCategoryIndex].isEmpty
                  ? [Container(height: height * 40 / 932)]
                  : List.generate(
                      lowerCategories[selectedUpperCategoryIndex].length,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 8.0 / 430),
                          child: ChoiceChip(
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            showCheckmark: false,
                            label: Text(
                              lowerCategories[selectedUpperCategoryIndex]
                                  [index],
                              style: TextStyle(
                                color: _selections[index]
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 35, 33, 33),
                                fontWeight: _selections[index]
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: width * 15 / 430,
                              ),
                            ),
                            selected: _selections[index],
                            selectedColor:
                                const Color.fromARGB(255, 122, 158, 209)
                                    .withOpacity(0.9),
                            onSelected: (bool selected) {
                              setState(() {
                                _selections[index] = selected;
                              });
                            },
                            backgroundColor: const Color(0xFFE6EDF7),
                            visualDensity: VisualDensity.compact,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: height * 5 / 932),
            height: height * 70 / 932,
            margin: EdgeInsets.only(
              top: height * 10 / 932,
            ),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: width * 0.3 / 430),
                ),
                //color: Colors.white,
                color: const Color.fromARGB(255, 242, 243, 247),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(
                        0, height * 3 / 932), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                CustomDropDown(
                  labelItems: labelItems,
                  selectedLabel: _selectLabel,
                  onChanged: (String? value) {
                    setState(() {
                      _selectLabel = value;
                    });
                  },
                  label: solved,
                  buttonSize: width * 100 / 430,
                ),
                SizedBox(
                  width: width * 70 / 430,
                ),
                Text(
                  "제목",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: width * 16 / 430,
                  ),
                ),
                SizedBox(
                  width: width * 95 / 430,
                ),
                CustomDropDown(
                  labelItems: bookmarkItems,
                  selectedLabel: _selectBookmark,
                  onChanged: (String? value) {
                    setState(() {
                      _selectLabel = value;
                    });
                  },
                  label: bookmark,
                  buttonSize: width * 120 / 430,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: height * 65 / 932,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1.5,
                        blurRadius: 5,
                        offset: Offset(
                          width * 5 / 430,
                          height * 3 / 932,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 10 / 430,
                      ),
                      Checkbox(
                        value: checkbox[index],
                        onChanged: null,
                      ),
                      SizedBox(
                        width: width * 40 / 430,
                      ),
                      Expanded(
                        child: TextButton(
                          style: const ButtonStyle(
                              alignment: Alignment.centerLeft),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChatInterviewScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            "QUESTION TITLE@@@@@@@@@@@",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 10 / 430,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 30 / 430),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isMarkedList[index] = !isMarkedList[index];
                            });
                          },
                          icon: isMarkedList[index]
                              ? Icon(
                                  Icons.bookmark_outlined,
                                  size: width * 30 / 430,
                                )
                              : Icon(
                                  Icons.bookmark_border_outlined,
                                  size: width * 30 / 430,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey.withOpacity(0.2), // 구분선의 배경색 설정
                  height: height * 1 / 932, // 구분선의 높이
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
