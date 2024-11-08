import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interview_app/models/question_model.dart';
import 'package:interview_app/screens/interview/chat_interview_screen.dart';
import 'package:interview_app/services/bookmark_service.dart';
import 'package:interview_app/services/question_service.dart';
import 'package:interview_app/widgets/custom_dropdown_widget.dart';

class InterviewListScreen extends StatefulWidget {
  const InterviewListScreen({super.key});

  @override
  State<InterviewListScreen> createState() => _InterviewListScreenState();
}

class _InterviewListScreenState extends State<InterviewListScreen> {
  int selectedUpperCategoryIndex = 0;
  late List<bool> _selections;
  StreamController<List<Question>> _questionsController =
      StreamController<List<Question>>();
  Stream<List<Question>> get questionsStream => _questionsController.stream;
  late List<Question> _currentQuestions;
  bool _isLoading = false; // 로딩 상태를 관리하는 변수

  final Map<String, List<String>> upperCategoryToLowerCategories = {
    "지식/기술": ["#프로그래밍", "#개발방법론", "#장애대응", "#기타"],
    "태도": ["#ICT 기술지향성", "#HW/SW 이해", "#정보보안", "#기타"],
    "인성역량": ["#도전정신", "#갈등관리", "#자기계발", "#협동성", "#기타"],
    "개인배경": ["#성격", "#가치관", "#개인사", "#기타"],
    "진정성": ["#진정성(직무)", "#진정성(회사)", "#기타"],
    "기타": []
  };

  final Map<String, String> upperCategoryMap = {
    "지식/기술": "technology",
    "태도": "attitude",
    "인성역량": "personality",
    "개인배경": "background",
    "진정성": "etc",
    "기타": "other",
  };

  final Map<String, String> lowerCategoryMap = {
    "#프로그래밍": "i_prg",
    "#개발방법론": "i_dev_mth",
    "#장애대응": "i_dis_coping",
    "#ICT 기술지향성": "i_tech_orien",
    "#HW/SW 이해": "i_hwsw_prfi",
    "#정보보안": "i_secty",
    "#도전정신": "c_chl",
    "#갈등관리": "c_confl_mg",
    "#자기계발": "c_imp",
    "#협동성": "c_cop",
    "#대응력": "c_adp",
    "#성격": "c_person",
    "#가치관": "c_value",
    "#개인사": "c_private",
    "#진정성(직무)": "c_sincere_job",
    "#진정성(회사)": "c_sincere_co",
    "#기타": "other",
  };

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
        upperCategoryToLowerCategories.values
            .toList()[selectedUpperCategoryIndex]
            .length,
        (index) => false);

    _selectLabel = "Show All";
    _selectBookmark = "Show All";
    fetchOptions();
  }

  @override
  void dispose() {
    _questionsController.close();
    super.dispose();
  }

  void updateQuestionBookmark(int questionId, int? bookmarkId) {
    final updatedQuestions = _currentQuestions.map((question) {
      if (question.questionId == questionId) {
        return Question(
          questionId: question.questionId,
          category: question.category,
          subCategory: question.subCategory,
          questionTitle: question.questionTitle,
          bookmarkId: bookmarkId,
          exerciseAnswerId: question.exerciseAnswerId,
        );
      }
      return question;
    }).toList();

    _currentQuestions = updatedQuestions;
    _questionsController.add(updatedQuestions);
  }

  void fetchOptions() async {
    if (mounted) {
      setState(() {
        _isLoading = true; // 데이터 로딩 시작
      });
    }

    // 선택된 상위 카테고리
    String selectedUpperCategory = upperCategoryToLowerCategories.keys
        .elementAt(selectedUpperCategoryIndex);
    String selectedUpperCategoryCode = upperCategoryMap[selectedUpperCategory]!;

    // 선택된 하위 카테고리 리스트
    List<String> selectedLowerCategories = [];

    // 선택된 하위 카테고리들을 추가
    for (int i = 0;
        i < upperCategoryToLowerCategories[selectedUpperCategory]!.length;
        i++) {
      if (_selections[i]) {
        selectedLowerCategories.add(lowerCategoryMap[
                upperCategoryToLowerCategories[selectedUpperCategory]![i]] ??
            'other');
      }
    }

    // 하위 카테고리가 선택되지 않은 경우 '모두 선택'으로 간주
    if (selectedLowerCategories.isEmpty) {
      selectedLowerCategories =
          upperCategoryToLowerCategories[selectedUpperCategory]!
              .map((category) => lowerCategoryMap[category] ?? 'other')
              .toList();
    }

    List<Question> questions = await QuestionService().fetchQuestions(
      category: selectedUpperCategoryCode,
      subCategory: selectedLowerCategories.isEmpty
          ? ''
          : selectedLowerCategories.join(','),
      bookmark: _selectBookmark == ("Show All")
          ? 'show all'
          : (_selectBookmark == "Not marked" ? 'false' : 'true'),
      context: context,
      answer: _selectLabel == "Show All"
          ? 'show all'
          : (_selectLabel == "Unsolved" ? 'false' : 'true'),
    );
    _questionsController.close();
    _questionsController = StreamController<List<Question>>();
    _currentQuestions = questions;
    _questionsController.add(questions);

    if (mounted) {
      setState(() {
        _isLoading = false; // 데이터 로딩 완료
      });
    }
  }

  Future<void> _addBookmark(int questionId) async {
    try {
      final bookmarkId = await BookmarkService.addBookmark(questionId);
      updateQuestionBookmark(questionId, bookmarkId);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to add bookmark: $e');
    }
  }

  Future<void> _removeBookmark(int questionId, int bookmarkId) async {
    try {
      await BookmarkService.removeBookmark(bookmarkId);
      updateQuestionBookmark(questionId, null);
      setState(() {});
    } catch (e) {
      // ignore: avoid_print
      print('Failed to remove bookmark: $e');
    }
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
                upperCategoryToLowerCategories.keys.length,
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
                              upperCategoryToLowerCategories.values
                                  .toList()[index]
                                  .length,
                              (index) => false);
                          fetchOptions();
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
                            upperCategoryToLowerCategories.keys
                                .elementAt(index),
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
          SizedBox(
            height: height * 48 / 932,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: upperCategoryToLowerCategories.values
                        .toList()[selectedUpperCategoryIndex]
                        .isEmpty
                    ? [
                        SizedBox(
                          height: height * 48 / 932,
                        ),
                      ]
                    : List.generate(
                        upperCategoryToLowerCategories.values
                            .toList()[selectedUpperCategoryIndex]
                            .length,
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
                                upperCategoryToLowerCategories.values
                                        .toList()[selectedUpperCategoryIndex]
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
                                  fetchOptions();
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
                      fetchOptions();
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
                  width: width * 80 / 430,
                ),
                CustomDropDown(
                  labelItems: bookmarkItems,
                  selectedLabel: _selectBookmark,
                  onChanged: (String? value) {
                    setState(() {
                      _selectBookmark = value;
                      fetchOptions();
                    });
                  },
                  label: bookmark,
                  buttonSize: width * 130 / 430,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading // 로딩 상태일 때
                ? const Center(
                    child: CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(242, 243, 247, 1),
                  ))
                : StreamBuilder<List<Question>>(
                    stream: questionsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Question>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Color.fromRGBO(242, 243, 247, 1),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('현재 카테고리는 비어있습니다.'));
                      } else {
                        final questionList = snapshot.data!;
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
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
                                children: [
                                  SizedBox(
                                    width: width * 10 / 430,
                                  ),
                                  Checkbox(
                                    value: snapshot
                                            .data![index].exerciseAnswerId !=
                                        null,
                                    onChanged: null,
                                  ),
                                  SizedBox(
                                    width: width * 40 / 430,
                                  ),
                                  Expanded(
                                    child: Tooltip(
                                      message:
                                          snapshot.data![index].questionTitle,
                                      child: TextButton(
                                        style: const ButtonStyle(
                                            alignment: Alignment.centerLeft),
                                        onPressed: () async {
                                          final isChanged =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatInterviewScreen(
                                                questionTitle: snapshot
                                                    .data![index].questionTitle,
                                                category: snapshot
                                                    .data![index].category,
                                                subCategory: snapshot
                                                    .data![index].subCategory,
                                                questionId: snapshot
                                                    .data![index].questionId,
                                                bookmarkId: snapshot
                                                    .data?[index].bookmarkId,
                                                exerciseAnswerId: snapshot
                                                    .data![index]
                                                    .exerciseAnswerId,
                                              ),
                                            ),
                                          );
                                          if (isChanged == true) {
                                            setState(() {
                                              fetchOptions();
                                            });
                                          }
                                        },
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          snapshot.data![index].questionTitle,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 10 / 430,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: width * 30 / 430),
                                    child: IconButton(
                                      onPressed: () {
                                        if (questionList[index].bookmarkId !=
                                            null) {
                                          _removeBookmark(
                                            questionList[index].questionId,
                                            questionList[index].bookmarkId!,
                                          );
                                          setState(() {});
                                        } else {
                                          _addBookmark(
                                              questionList[index].questionId);
                                          setState(() {});
                                        }
                                      },
                                      icon: questionList[index].bookmarkId !=
                                              null
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
                              color:
                                  Colors.grey.withOpacity(0.2), // 구분선의 배경색 설정
                              height: height * 1 / 932, // 구분선의 높이
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
