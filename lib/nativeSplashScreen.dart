import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'loginScreen.dart';

class NativeSplashScreen extends StatefulWidget {
  const NativeSplashScreen({super.key});

  @override
  State<NativeSplashScreen> createState() => _NativeSplashScreenState();
}

class _NativeSplashScreenState extends State<NativeSplashScreen> {

  @override
  void initState() {
    super.initState();
   // initialization();

    print('nativeSplashScreen init 호출');

  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    //await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    //await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    //await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
    //navigationPage();
  }

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    print('LoginPage로');
    // 무조건 빌드가 끝난후에 실행하게 한다. WidgetsBinding.instance!.addPostFrameCallback()
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.goNamed('login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LogInScreen(),
    );
  }
}
