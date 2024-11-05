import 'package:flutter/material.dart';
import 'package:interview_app/models/log_mock_models.dart';
import 'package:interview_app/models/mock_interview_models.dart';
import 'package:interview_app/screens/interview/test_interview_screen.dart';
import 'package:interview_app/services/mock_service.dart';

class LogInterviewScreen extends StatefulWidget {
  const LogInterviewScreen({super.key});

  @override
  State<LogInterviewScreen> createState() => _LogInterviewScreenState();
}

class _LogInterviewScreenState extends State<LogInterviewScreen> {
  late Future<List<LogMockModels>> logMockInterview;
  double averageScore = 0;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int latestRound = 1;
  @override
  void initState() {
    super.initState();
    logMockInterview = MockService.fetchLogMockInterview();
    logMockInterview.then((list) {
      if (list.isNotEmpty) {
        averageScore = _calculateAverageScore(list);
      }
      setState(() {}); // 평균 점수 계산 후 UI 갱신
    });
  }

  double _calculateAverageScore(List<LogMockModels> logs) {
    if (logs.isNotEmpty) {
      int totalScore = 0;
      int totalLength = 0;
      for (var log in logs) {
        if (log.totalScore != 0) {
          totalScore += log.totalScore!;
          totalLength++;
        }
      }
      averageScore = totalScore / totalLength;
      return averageScore;
    } else {
      return 0;
    }
  }

  void deleteAllInterview() async {
    bool suc = await MockService.fetchDeleteAllMockInterview();
    if (suc == true) {
      await MockService.fetchLogMockInterview();
      setState(() {});
    }
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'T E S T',
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("면접을 시작하시겠습니까?"),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('아니오'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('예'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    startNewMockInterview();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> showContinueInterview() async {
    double font = (MediaQuery.of(context).size.width * 18 / 430);
    int choiceIndex = -1; // 선택된 테스트 변수 추가
    List<LogMockModels> logmock =
        await MockService.fetchExistingLogMockInterview();

    // logmock이 비어있는 경우, 진행할 수 없음을 알리고 리턴
    if (logmock.isEmpty) {
      // 사용자에게 알림 표시 또는 다른 처리
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('진행할 수 있는 면접 기록이 없습니다.')),
      );
      return;
    }

    logmock.sort((a, b) => b.round.compareTo(a.round));
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            title: Text(
              "이어서 하기",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: font, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                for (int i = 0; i < logmock.length; i++)
                  ChoiceChip(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      "${logmock[i].round} 회차",
                      style: TextStyle(fontSize: font),
                    ),
                    labelPadding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width * 80 / 430,
                        vertical:
                            MediaQuery.of(context).size.height * 12 / 932),
                    visualDensity: VisualDensity.compact,
                    selected: choiceIndex == i,
                    selectedColor: Colors.blue,
                    showCheckmark: false,
                    onSelected: (selected) {
                      setState(() {
                        if (choiceIndex == i) {
                          choiceIndex = -1; // -1로 설정하여 선택 해제
                        } else {
                          choiceIndex =
                              i; // 새로운 칩을 선택하면 choiceIndex를 해당 인덱스로 변경
                        }
                      });
                    },
                  ),
              ],
            )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop(); // 대화 상자 닫기
                    },
                  ),
                  TextButton(
                    child: const Text('진행'),
                    onPressed: () {
                      Navigator.of(context).pop();

                      dynamic isChanged =
                          continueInterview(context, choiceIndex, logmock);

                      if (isChanged == true && mounted) {
                        setState(() {
                          logMockInterview =
                              MockService.fetchLogMockInterview();
                          logMockInterview.then((list) {
                            if (list.isNotEmpty) {
                              averageScore = _calculateAverageScore(list);
                            }
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> continueInterview(BuildContext context, int choiceIndex,
      List<LogMockModels> logmock) async {
    final isChanged = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestInterviewScreen(
            logMockInterviewId: (choiceIndex == -1)
                ? logmock[0].logMockInterviewId
                : logmock[choiceIndex].logMockInterviewId,
            round: (choiceIndex == -1)
                ? logmock[0].round
                : logmock[choiceIndex].round),
      ),
    );
    return isChanged;
  }

  Future<void> startNewMockInterview() async {
    // 비동기 작업 실행
    MockInterviewModels mockInterviews =
        await MockService.startNewMockInterview();
    int logMockInterviewId = mockInterviews.logMockInterviewId;
    // mounted 상태 확인
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestInterviewScreen(
          logMockInterviewId: logMockInterviewId,
          round: latestRound + 1,
        ),
      ),
    );

    setState(() {
      logMockInterview = MockService.fetchLogMockInterview();
      logMockInterview.then((list) {
        if (list.isNotEmpty) {
          averageScore = _calculateAverageScore(list);
        }
      });
    });
  }

  void scrollToIndex(int index) {
    double offset = (index) * MediaQuery.of(context).size.height * 90 / 932;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: width * 20 / 430,
          right: width * 20 / 430,
          top: height * 30 / 932),
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
                            offset: Offset(width * 10 / 430, height * 2 / 932),
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
                                      deleteAllInterview();
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
                              "${averageScore.toInt()}",
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(13),
                          onTap: showConfirmationDialog,
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
                                  color:
                                      const Color.fromARGB(255, 216, 221, 224),
                                  size: width * 30 / 430,
                                ),
                              ],
                            ),
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(13),
                          onTap: () {
                            showContinueInterview();
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
                                  color:
                                      const Color.fromARGB(255, 216, 221, 224),
                                  size: width * 30 / 430,
                                ),
                              ],
                            ),
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
            height: height * 7 / 932,
          ),
          Expanded(
            child: FutureBuilder(
                future: logMockInterview,
                builder: (BuildContext context,
                    AsyncSnapshot<List<LogMockModels>> snapshot) {
                  latestRound = snapshot.data?.length ?? 1;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 데이터가 로딩 중일 때 로딩 인디케이터 표시
                    return const Center(
                      child: CircularProgressIndicator(), // 로딩 인디케이터
                    );
                  } else if (snapshot.hasError) {
                    // 에러가 발생한 경우 에러 메시지 표시
                    return Center(
                      child: Text('Error: ${snapshot.error}'), // 에러 메시지
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // 데이터가 없을 경우
                    return const Center(
                      child: Text('No records found.'), // 데이터가 없다는 메시지
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 30 / 430,
                        vertical: height * 10 / 932),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                                color: const Color(0xFF13548f),
                                child: Center(
                                  child: Text(
                                    '${snapshot.data?[index].round}',
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
                                snapshot.data?[index].totalScore == 0
                                    ? "미완료"
                                    : "${snapshot.data?[index].totalScore}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 16 / 430,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right),
                              onPressed: () async {
                                final isChanged = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestInterviewScreen(
                                        logMockInterviewId: snapshot
                                            .data![index].logMockInterviewId,
                                        round: snapshot.data![index].round),
                                  ),
                                );
                                if (isChanged == true && mounted) {
                                  setState(() {
                                    logMockInterview =
                                        MockService.fetchLogMockInterview();
                                    logMockInterview.then((list) {
                                      if (list.isNotEmpty) {
                                        averageScore =
                                            _calculateAverageScore(list);
                                      }
                                    });
                                  });
                                }
                              },
                              iconSize: width * 30 / 430,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
          const Divider(
            color: Color.fromRGBO(214, 216, 219, 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 2 / 932, horizontal: width * 35 / 430),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: width * 18 / 430),
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: '회차 검색',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    onSubmitted: (String value) {
                      if (latestRound > 0) {
                        // 기록이 있는지 확인
                        int index = int.tryParse(value) ?? -1;
                        if (index >= 5 && index <= latestRound) {
                          scrollToIndex(latestRound - index);
                        } else if (index > 0 && index <= 4) {
                          scrollToIndex(latestRound - 4);
                        }
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (latestRound > 0) {
                      // 기록이 있는지 확인
                      int index = int.tryParse(_searchController.text) ?? -1;
                      if (index >= 5 && index <= latestRound) {
                        scrollToIndex(latestRound - index);
                      } else if (index > 0 && index <= 4) {
                        scrollToIndex(latestRound - 4);
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
                  onPressed: () {
                    if (latestRound > 0) {
                      // 기록이 있는지 확인
                      scrollToIndex(0);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
