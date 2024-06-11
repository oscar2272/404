import 'package:flutter/material.dart';

class LogCard extends StatefulWidget {
  final int index;
  final int value;
  final Function onDragged;
  final Color color;
  final String feedback;
  const LogCard(
      {super.key,
      required this.index,
      required this.onDragged,
      required this.value,
      required this.color,
      required this.feedback});

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> with TickerProviderStateMixin {
  Offset _position = const Offset(0, 0);

  Curve _myCurve = Curves.linear;
  Duration _duration = const Duration(milliseconds: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      left: _position.dx,
      top:
          ((height / 4) - (height * 0.5 / 2) + (widget.index * height * 0.05)) +
              _position.dy,

      // (_position.dy - (widget.index * 15)),
      duration: _duration,
      curve: _myCurve,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (widget.index == 4) {
            _myCurve = Curves.linear;
            _duration = const Duration(milliseconds: 0);
            if (width >= 100 || height >= 100) {
              width -= 4;
              height -= 1;
            }

            _position += details.delta;
            setState(() {});
          }
        },
        onPanEnd: (details) {
          if (widget.index == 4) {
            _myCurve = Curves.easeIn;
            _duration = const Duration(milliseconds: 300);
            setState(() {
              if (_position.dx <= -(width / 2) || _position.dx >= (width / 2)) {
                // If so, move the card to the back (0th index)
                widget.onDragged();

                _position = Offset.zero;
              } else {
                _position = Offset.zero;
              }
              height = height * 400 / 932;

              width = width * 350 / 430;
            });
          }
        },
        child: AnimatedContainer(
          height: height * 400 / 932,
          width: width * 350 / 430,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(widget.feedback),
                Text("Item ${widget.value}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _animateCardBack() {
  //   // _animationController.forward();
  // }

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }
}
