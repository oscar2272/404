import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:interview_app/widgets/bubble_normal_widget.dart';

class ChatInterviewScreen extends StatefulWidget {
  const ChatInterviewScreen({super.key});

  @override
  State<ChatInterviewScreen> createState() => _ChatInterviewScreenState();
}

class _ChatInterviewScreenState extends State<ChatInterviewScreen> {
  late bool isMarked = false;
  final scrollController = ScrollController();

  List<BubbleNormalWidget> messages = [
    const BubbleNormalWidget(
      text:
          "first...................................................................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...................................................................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",
      isSender: false,
      color: Color(0xFFE8E8EE),
      tail: true,
      textColor: Colors.black,
    ),
    const BubbleNormalWidget(
      text:
          "second...................................................................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",
      isSender: true,
      color: Color(0xFF1B97F3),
      tail: true,
      textColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();
    messages = messages.reversed.toList(); // 초기화 단계에서 리스트를 역순으로 변환
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool showMessageBar = (messages.length != 3);

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

      updateUI();
    }

    void deleteMessage() {
      messages = messages.reversed.toList();
      messages.removeLast();

      setState(() {
        messages = messages.reversed.toList();
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: height * 70 / 932,
        leadingWidth: width * 35 / 430,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: width * 27 / 430,
            color: const Color(0xFF586571),
          ),
        ),
        backgroundColor: const Color(0xFF111D27),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "문제풀기",
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 148, 158, 168),
              ),
            ),
            Icon(
              Icons.chevron_right_sharp,
              size: width * 22 / 430,
              color: const Color.fromARGB(255, 148, 158, 168),
            ),
            Text(
              "i-prg",
              style: TextStyle(
                fontSize: width * 18 / 430,
                color: const Color.fromARGB(255, 148, 158, 168),
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 20 / 430),
            child: IconButton(
              icon: isMarked
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
              onPressed: () {
                setState(() {
                  isMarked = !isMarked;
                });
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
            if (showMessageBar)
              Positioned(
                bottom: height * 20 / 932,
                left: 0,
                right: 0,
                child: MessageBar(
                  onSend: (message) {
                    addMessage(
                      BubbleNormalWidget(
                        text: message,
                        isSender: true, // 사용자가 보내는 메시지이므로 true
                        color: const Color(0xFF1B97F3),
                        tail: true,
                        textColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
