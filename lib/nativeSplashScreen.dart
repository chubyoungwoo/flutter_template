import 'package:flutter/material.dart';

class NativeSplashScreen extends StatefulWidget {
  const NativeSplashScreen({super.key});

  @override
  State<NativeSplashScreen> createState() => _NativeSplashScreenState();
}

class _NativeSplashScreenState extends State<NativeSplashScreen> {
  @override
  void initState() {
    super.initState();

    print('nativeSplashScreen init 호출');
  }

/*
  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    print('LoginPage로');
    // 무조건 빌드가 끝난후에 실행하게 한다. WidgetsBinding.instance!.addPostFrameCallback()
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.goNamed('login');
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.384375),
              const Image(
                image: AssetImage('assets/images/splash.jpg'),
              ),
              const Expanded(child: SizedBox()),
              Align(
                child: Text("© Copyright 2023, 스플레쉬(CBW)",
                    style: TextStyle(
                      fontSize: screenWidth * (14 / 360),
                      color: const Color.fromRGBO(255, 255, 255, 0.6),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0625,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
