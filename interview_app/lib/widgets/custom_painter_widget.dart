import 'package:flutter/material.dart';

class LeftBorderPainter extends CustomPainter {
  final Color color;
  final double height;
  final double width;
  LeftBorderPainter(this.color, this.height, this.width);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color // 선의 색상을 원하는 색상으로 지정하세요.
      ..strokeWidth = 10 // 선의 두께를 원하는 두께로 지정하세요.
      ..strokeCap = StrokeCap.square; // 선의 끝 모양을 원하는 모양으로 지정하세요.

    canvas.drawLine(
      const Offset(5, 20), // 선의 시작점을 지정하세요. 여기서는 왼쪽 상단부터 시작합니다.
      Offset(5, height - 20), // 선의 끝점을 지정하세요. 여기서는 왼쪽 하단까지입니다.
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
