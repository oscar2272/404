import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 242, 235, 235),
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(0, 3),
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
          const SizedBox(
            height: 60,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: lowerCategories[selectedUpperCategoryIndex].isEmpty
                  ? [Container(height: 40)]
                  : List.generate(
                      lowerCategories[selectedUpperCategoryIndex].length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                fontSize: 15,
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
            height: 65,
            margin: const EdgeInsets.only(
              top: 10,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 23, 24, 30),
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
                  buttonSize: 100,
                ),
                const SizedBox(
                  width: 70,
                ),
                const Text(
                  "제목",
                  style: TextStyle(
                    color: Color.fromARGB(225, 255, 255, 255),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 95,
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
                  buttonSize: 120,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1.5,
                        blurRadius: 5,
                        offset:
                            const Offset(5, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        value: checkbox[index],
                        onChanged: null,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const Text("QUESTION TITLE"), //question_title
                      const SizedBox(
                        width: 105,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isMarkedList[index] = !isMarkedList[index];
                          });
                        },
                        icon: isMarkedList[index]
                            ? const Icon(Icons.bookmark_outlined)
                            : const Icon(
                                Icons.bookmark_border_outlined,
                              ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey.withOpacity(0.2), // 구분선의 배경색 설정
                  height: 1, // 구분선의 높이
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
