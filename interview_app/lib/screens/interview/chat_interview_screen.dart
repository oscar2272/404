import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:interview_app/models/exercise_answer_model.dart';
import 'package:interview_app/services/bookmark_service.dart';
import 'package:interview_app/services/exercise_answer_service.dart';
import 'package:interview_app/widgets/bubble_normal_widget.dart';

// ignore: must_be_immutable
class ChatInterviewScreen extends StatefulWidget {
  final int questionId;
  int? bookmarkId, exerciseAnswerId;

  final String questionTitle;
  final String category, subCategory;
  ChatInterviewScreen(
      {super.key,
      required this.questionTitle,
      required this.category,
      required this.subCategory,
      required this.questionId,
      required this.bookmarkId,
      required this.exerciseAnswerId});

  @override
  State<ChatInterviewScreen> createState() => _ChatInterviewScreenState();
}

class _ChatInterviewScreenState extends State<ChatInterviewScreen> {
  final scrollController = ScrollController();
  late final ExerciseAnswer? answer;
  bool isBookmarked = false;
  bool isBookmarkChanged = false;
  bool isAnsweredChanged = false;
  bool isLoading = false;
  bool showRetryButton = false;
  late bool showMessageBar;
  late List<BubbleNormalWidget> messages;

  @override
  initState() {
    super.initState();
    messages = [];
    if (widget.exerciseAnswerId != null) {
      _initializeData();
    } else {
      messages = [
        BubbleNormalWidget(
          text: widget.questionTitle,
          isSender: false,
          color: const Color(0xFFE8E8EE),
          tail: true,
          textColor: Colors.black,
        ),
      ];
    }
    messages = messages.reversed.toList(); // 초기화 단계에서 리스트를 역순으로 변환
    isBookmarked = (widget.bookmarkId != null);
  }

  Future<void> _initializeData() async {
    // 데이터 불러오기
    final answer = await ExerciseAnswerService.getAnswer(
        widget.exerciseAnswerId, widget.questionId);

    // 불러온 데이터에 따라 메시지 추가
    addMessage(
      BubbleNormalWidget(
        text: widget.questionTitle,
        isSender: false,
        color: const Color(0xFFE8E8EE),
        tail: true,
        textColor: Colors.black,
      ),
    );
    addMessage(
      BubbleNormalWidget(
        text: answer.answer,
        isSender: true,
        color: const Color(0xFF1B97F3),
        textColor: Colors.white,
        tail: true,
      ),
    );
    addMessage(
      BubbleNormalWidget(
        text: answer.feedback,
        isSender: false,
        color: const Color(0xFFE8E8EE),
        tail: true,
        textColor: Colors.black,
      ),
    );

    // UI 업데이트
    updateUI();
  }

  void toggleBookmark() async {
    if (isBookmarked == false) {
      final newBookmarkId =
          await BookmarkService.addBookmark(widget.questionId);
      widget.bookmarkId = newBookmarkId;
      isBookmarkChanged = true;
    } else {
      await BookmarkService.removeBookmark(widget.bookmarkId!);
      isBookmarkChanged = true;
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void updateUI() {
    setState(() {
      showMessageBar = messages.length != 3;
    });
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
    showRetryButton = true;
    updateUI();
  }

  void deleteMessage() {
    messages = messages.reversed.toList();
    messages.removeLast();

    setState(() {
      messages = messages.reversed.toList();
    });
  }

  Future<void> sendMessage(String message) async {
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
      showRetryButton = false; // 응답을 받기 전에는 다시 시도 버튼을 숨깁니다.
    });

    try {
      final response = await ExerciseAnswerService.sendMessageToServer(
          message, widget.questionId);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        widget.exerciseAnswerId = responseData['exercise_answer_id'];
        addMessage(
          BubbleNormalWidget(
            text: responseData['gpt_response'],
            isSender: false,
            color: const Color(0xFFE8E8EE),
            tail: true,
            textColor: Colors.black,
          ),
        );
        setState(() {
          showRetryButton = true; // 응답을 성공적으로 받은 경우에만 다시 시도 버튼을 보입니다.
          isAnsweredChanged = !isAnsweredChanged;
        });
      } else {
        showErrorAndRetry("서버 응답 오류: 다시 시도해 주세요.", message);
      }
    } catch (e) {
      showErrorAndRetry("네트워크 오류: 다시 시도해 주세요.", message);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resetInterview() async {
    if (widget.exerciseAnswerId != null) {
      final result =
          await ExerciseAnswerService.removeAnswer(widget.exerciseAnswerId!);
      if (result == 'success') {
        setState(() {
          widget.exerciseAnswerId = null;
          isAnsweredChanged = !isAnsweredChanged;
          showRetryButton = false; // 다시 시도 버튼 숨기기
          deleteMessage();
          deleteMessage();
        });
        updateUI();
      } else {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('오류 발생'),
                content: const Text('답변 삭제에 실패했습니다. 다시 시도해 주세요.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('확인'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  void showErrorAndRetry(String errorMessage, String originalMessage) {
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
                sendMessage(originalMessage); // 메시지 재전송
              },
              child: const Text('다시 시도'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool showMessageBar = (messages.length != 3);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 248),
      resizeToAvoidBottomInset: true, // 키보드가 화면을 가릴 때 자동으로 위로 올리기
      appBar: AppBar(
        toolbarHeight: height * 70 / 932,
        leadingWidth: width * 35 / 430,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, isBookmarkChanged || isAnsweredChanged);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: width * 27 / 430,
            color: const Color(0xFF586571),
          ),
        ),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 89, 95, 102),
              ),
            ),
            SizedBox(
              width: width * 10 / 430,
            ),
            Text(
              ":",
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 89, 95, 102),
              ),
            ),
            SizedBox(
              width: width * 10 / 430,
            ),
            Text(
              widget.subCategory,
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 89, 95, 102),
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 20 / 430),
            child: IconButton(
              icon: isBookmarked
                  ? Icon(
                      color: const Color.fromARGB(255, 148, 158, 168),
                      Icons.bookmark_outlined,
                      size: width * 35 / 430,
                    )
                  : Icon(
                      color: const Color.fromARGB(255, 148, 158, 168),
                      Icons.bookmark_border_outlined,
                      size: width * 35 / 430,
                    ),
              onPressed: toggleBookmark,
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
            if (!showMessageBar)
              Positioned(
                left: 0,
                right: 0,
                bottom: height * 40 / 932,
                child: TextButton.icon(
                  onPressed: deleteMessage,
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
            if (showRetryButton)
              Positioned(
                left: 0,
                right: 0,
                bottom: height * 40 / 932,
                child: TextButton.icon(
                  onPressed: resetInterview,
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
                    sendMessage(message);
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
