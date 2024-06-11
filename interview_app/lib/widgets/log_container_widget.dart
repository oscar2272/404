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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 15 / 430),
      width: width * 150 / 430,
      height: height * 20 / 932,
      margin: EdgeInsets.symmetric(
          horizontal: width * 10 / 430, vertical: height * 10 / 932),
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
          SizedBox(
            height: height * 35 / 932,
          ),
          Row(
            children: [
              // Image.asset(
              //   "assets/it.png",
              //   height: 26,
              //   width: 26,
              // ),
              SizedBox(
                width: width * 7 / 430,
              ),
              Text(
                category,
                style: TextStyle(
                    color: textColor,
                    fontSize: width * 18 / 430,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: height * 60 / 932,
          ),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(6),
            value: 0.7,
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 116, 161, 225)),
            backgroundColor: const Color.fromARGB(255, 241, 237, 251),
            minHeight: height * 20 / 932,
          )
        ],
      ),
    );
  }
}
