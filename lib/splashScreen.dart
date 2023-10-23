import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    // 1초가 지나면 navigationPage 함수가 작동한다.
    var _duration = Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    context.goNamed('login');
  }

  @override
  void initState() {
    //앱이 시작되면 시간을 재기 시작한다.
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // 앱의 로고가 스플래시 화면으로 뜨게 된다.
        child: Image.asset('assets/images/dog.png'),
      ),
    );
  }
}
