import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';

class BubbleNormalWidget extends StatelessWidget {
  final String text;
  final bool isSender;
  final Color color;
  final Color textColor;
  final bool tail;

  const BubbleNormalWidget({
    super.key,
    required this.text,
    required this.isSender,
    required this.color,
    required this.textColor,
    required this.tail,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BubbleNormal(
      text: text,
      isSender: isSender,
      color: color,
      tail: tail,
      textStyle: TextStyle(
        fontSize: width * 20 / 430,
        color: textColor,
      ),
    );
  }
}
