import 'package:flutter/material.dart';
import 'package:interview_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //   print(
    //       "size: ${MediaQuery.of(context).size}"); //앱 화면 크기 size  Ex> Size(360.0, 692.0)
    //   print(
    //       "height: ${MediaQuery.of(context).size.height}"); //앱 화면 높이 double Ex> 692.0
    //   print(
    //       "width: ${MediaQuery.of(context).size.width}"); //앱 화면 넓이 double Ex> 360.0
    //   print(
    //       "devicePixelRatio: ${MediaQuery.of(context).devicePixelRatio}"); //화면 배율    double Ex> 4.0
    //   print("padding top: ${MediaQuery.of(context).padding.top}");

    //   print(
    //       "height: ${MediaQueryData.fromView(WidgetsBinding.instance.window).size.height}");
    //   print(
    //       "width: ${MediaQueryData.fromView(WidgetsBinding.instance.window).size.width}");

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
      title: 'InterviewApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
// 430 x 932