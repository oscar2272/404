import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:interview_app/models/mock_interview_models.dart';
import 'package:interview_app/services/mock_service.dart';
import 'package:interview_app/widgets/bubble_normal_widget.dart';

class TestInterviewScreen extends StatefulWidget {
  final int logMockInterviewId;
  final int round;

  const TestInterviewScreen({
    super.key,
    required this.logMockInterviewId,
    required this.round,
  });

  @override
  State<TestInterviewScreen> createState() => _TestInterviewScreenState();
}

class _TestInterviewScreenState extends State<TestInterviewScreen> {
  late bool isMarked = false;
  late bool showMessageBar;
  bool failed = false;
  bool isLoading = false;
  bool isAnsweredChanged = false;
  bool showRetryButton = false;
  final scrollController = ScrollController();
  late Future<List<MockInterviewModels>> mockInterviews;

  List<BubbleNormalWidget> messages = [
    const BubbleNormalWidget(
      text: "발화의도, 성장가능성, 논리적표현, 인성, 전문지식 5개를 기반으로 평가가 이루어집니다.",
      isSender: false,
      color: Color(0xFFE8E8EE),
      tail: true,
      textColor: Colors.black,
    ),
  ];
  @override
  void initState() {
    super.initState();
    showMessageBar = (messages.length != 14);

    failed ==
        messages
            .any((message) => message.text != "요청을 실패했습니다 면접을 삭제하고 다시시작해주세요");
    mockInterviews =
        getMockInterview(widget.logMockInterviewId); // mock객체를 받아오는 메서드 호출
    messages = messages.reversed.toList(); // 초기화 단계에서 리스트를 역순으로 변환
  }

  Future<List<MockInterviewModels>> getMockInterview(
      int logMockInterviewId) async {
    try {
      List<MockInterviewModels> mockInterviews =
          await MockService.fetchMockInterview(logMockInterviewId);

      getMessages(mockInterviews); // 데이터를 받아와 getMessages 호출

      setState(() {
        failed = false; //??
      });
      return mockInterviews;
    } catch (e) {
      return [];
    }
  }

  void getMessages(List<MockInterviewModels> mockInterviews) {
    if (failed) {
    } else {
      mockInterviews.sort((a, b) => a.questionNum.compareTo(b.questionNum));

      //첫번째 질문만 하고 나왔을때 (length가 1이고 answer가 null인경우)
      if ((mockInterviews.length == 1) && mockInterviews[0].answer == '') {
        addMessage(
          BubbleNormalWidget(
            text: '1번째 질문입니다. ${mockInterviews[0].questionTitle}',
            isSender: false,
            color: const Color(0xFFE8E8EE),
            tail: true,
            textColor: Colors.black,
          ),
        );
      } else if (mockInterviews.length == 6 && mockInterviews[5].answer == '') {
        int index = 0;
        for (int i = 0; i < 6; i++) {
          if (mockInterviews[i].answer == "") {
            index = i;
          }
        }
        for (int i = 0; i < index; i++) {
          addMessage(
            BubbleNormalWidget(
              text:
                  '${mockInterviews[i].questionNum}번째 질문입니다. ${mockInterviews[i].questionTitle}',
              isSender: false,
              color: const Color(0xFFE8E8EE),
              tail: true,
              textColor: Colors.black,
            ),
          );
          if (mockInterviews[i].answer.isNotEmpty) {
            addMessage(
              BubbleNormalWidget(
                text: mockInterviews[i].answer,
                isSender: true,
                color: const Color(0xFF1B97F3),
                tail: true,
                textColor: Colors.white,
              ),
            );
          }
          if (index == 5) {
            addMessage(
              BubbleNormalWidget(
                text: mockInterviews[index].feedback,
                isSender: false,
                color: const Color(0xFFE8E8EE),
                tail: true,
                textColor: Colors.black,
              ),
            );
          }
        }
      } else if (mockInterviews.length == 6 &&
          mockInterviews.every((interview) => interview.answer == "")) {
        // 다시하기인경우

        addMessage(
          BubbleNormalWidget(
            text: '1번째 질문입니다. ${mockInterviews[0].questionTitle}',
            isSender: false,
            color: const Color(0xFFE8E8EE),
            tail: true,
            textColor: Colors.black,
          ),
        );
      } else {
        for (int i = 0; i < mockInterviews.length; i++) {
          addMessage(
            BubbleNormalWidget(
              text:
                  '${mockInterviews[i].questionNum}번째 질문입니다. ${mockInterviews[i].questionTitle}',
              isSender: false,
              color: const Color(0xFFE8E8EE),
              tail: true,
              textColor: Colors.black,
            ),
          );
          if (mockInterviews[i].answer.isNotEmpty) {
            addMessage(
              BubbleNormalWidget(
                text: mockInterviews[i].answer,
                isSender: true,
                color: const Color(0xFF1B97F3),
                tail: true,
                textColor: Colors.white,
              ),
            );
          }
          if (i == 5) {
            addMessage(
              BubbleNormalWidget(
                text: mockInterviews[i].feedback,
                isSender: false,
                color: const Color(0xFFE8E8EE),
                tail: true,
                textColor: Colors.black,
              ),
            );
            return;
          }
        }
      }
      updateUI();
    }
  }

  void addMessage(BubbleNormalWidget message) {
    messages = messages.reversed.toList();

    messages.add(message);
    setState(() {
      messages = messages.reversed.toList();
    });
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    updateUI();
  }

  void showErrorAndRetry(
      String errorMessage, String originalMessage, int logMockInterviewId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류 발생'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteMessage(); // 이전에 추가한 메시지 삭제
              },
              child: const Text('닫기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteMessage();
                sendMessage(originalMessage, logMockInterviewId); // 메시지 재전송
              },
              child: const Text('다시 시도'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendMessage(String message, int logMockInterviewId) async {
    FocusScope.of(context).unfocus();
    addMessage(
      BubbleNormalWidget(
        text: message,
        isSender: true,
        color: const Color(0xFF1B97F3),
        tail: true,
        textColor: Colors.white,
      ),
    );
    setState(() {
      isLoading = true;
      showRetryButton = false;
    });

    try {
      Map<String, dynamic> mock =
          await MockService.submitAnswer(message, logMockInterviewId);
      if (mock["message"] != "요청을 실패했습니다 다시 시작해주세요" && message != '') {
        if (mock["question_title"] != null) {
          addMessage(BubbleNormalWidget(
            text: "${mock["question_num"]}번째 질문입니다. ${mock["question_title"]}",
            isSender: false,
            color: const Color(0xFFE8E8EE),
            tail: true,
            textColor: Colors.black,
          ));

          setState(() {
            isAnsweredChanged = true;
          });
        }
        if (mock["gpt_response"] != null) {
          addMessage(BubbleNormalWidget(
            text: "${mock["gpt_response"]}",
            isSender: false,
            color: const Color.fromRGBO(232, 232, 238, 1),
            tail: true,
            textColor: Colors.black,
          ));
          setState(() {
            updateUI();
          });
        }
      } else {
        // 오류 발생 시 재시도 옵션 제공
        showErrorAndRetry("서버 응답 오류: 다시 시도해 주세요.", message, logMockInterviewId);
      }
    } catch (e) {
      // 네트워크 오류 발생 시 재시도 옵션 제공
      showErrorAndRetry("네트워크 오류: 다시 시도해 주세요.", message, logMockInterviewId);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateUI() {
    setState(() {
      showMessageBar = (messages.length != 14);
      showRetryButton = (messages.length == 14);
    });
  }

  void deleteMessage() {
    messages = messages.reversed.toList();
    messages.removeLast();

    setState(() {
      messages = messages.reversed.toList();
    });
  }

  void deleteUserMessage() async {
    bool del =
        await MockService.fetchDeleteUserMessage(widget.logMockInterviewId);

    if (del) {
      await MockService.fetchMockInterview(widget.logMockInterviewId);

      setState(() {
        showRetryButton = false; // 다시 시도 버튼 숨기기
        for (int i = 0; i < 12; i++) {
          deleteMessage(); // 12번 반복
        }
      });
    }
  }

  void deleteAllMessages() async {
    bool del =
        await MockService.fetchDeleteMockInterview(widget.logMockInterviewId);
    if (del) {
      if (!mounted) return;
      Navigator.pop(context, true);
      return;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: height * 70 / 932,
        leadingWidth: width * 35 / 430,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: width * 27 / 430,
            color: const Color(0xFF586571),
          ),
        ),
        backgroundColor: const Color(0xFF111D27),
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${widget.round}회차 모의면접",
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 148, 158, 168),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 20 / 430),
            child: PopupMenuButton<bool>(
              icon: const Icon(Icons.more_horiz_outlined),
              iconColor: Colors.white,
              iconSize: width * 35 / 430,
              onSelected: (bool value) {
                if (value) {
                  deleteAllMessages();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: false,
                    child: Center(
                      child: Text(
                        "닫기",
                        style: TextStyle(
                          fontSize: width * 15 / 430,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: true,
                    child: Center(
                      child: Text(
                        "해당 면접 삭제",
                        style: TextStyle(
                          fontSize: width * 15 / 430,
                        ),
                      ),
                    ),
                  )
                ];
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // <-- 가상 키보드 숨기기
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                controller: scrollController,
                padding: EdgeInsets.only(bottom: height * 80 / 932, top: 0),
                children: <Widget>[
                  SizedBox(
                    height: height * 20 / 932,
                  ),
                  ...messages,
                  SizedBox(
                    height: height * 40 / 932,
                  ),
                ],
              ),
            ),
            if (!showMessageBar && showRetryButton)
              Positioned(
                left: 0,
                right: 0,
                bottom: height * 40 / 932,
                child: TextButton.icon(
                  onPressed: deleteUserMessage,
                  icon: Icon(
                    Icons.refresh_outlined,
                    size: width * 24 / 430,
                  ),
                  label: Text(
                    "다시하기",
                    style: TextStyle(fontSize: width * 18 / 430),
                  ),
                ),
              ),
            if (!showRetryButton)
              Positioned(
                bottom: height * 20 / 932,
                left: 0,
                right: 0,
                child: MessageBar(
                  onSend: (message) {
                    sendMessage(message, widget.logMockInterviewId);
                  },
                ),
              ),
            if (isLoading)
              Positioned(
                left: 0,
                right: 0,
                bottom: height * 466 / 932,
                child: const Center(
                  child: CircularProgressIndicator(), // 로딩 스피너 추가
                ),
              ),
          ],
        ),
      ),
    );
  }
}
