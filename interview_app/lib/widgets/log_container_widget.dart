import 'package:flutter/material.dart';

class LogContainer extends StatelessWidget {
  final int index;
  final Color color, textColor;
  final String category;

  const LogContainer(this.index,
      {super.key,
      required this.color,
      required this.category,
      required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 150,
      height: 150,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1.5,
            blurRadius: 5,
            offset: const Offset(5, 3), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(75.0),
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Row(
            children: [
              // Image.asset(
              //   "assets/it.png",
              //   height: 26,
              //   width: 26,
              // ),
              const SizedBox(
                width: 7,
              ),
              Text(
                category,
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(6),
            value: 0.7,
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 116, 161, 225)),
            backgroundColor: const Color.fromARGB(255, 241, 237, 251),
            minHeight: 17,
          )
        ],
      ),
    );
  }
}
