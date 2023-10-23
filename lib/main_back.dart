import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_template/screens/profileScreen.dart';

import 'homeScreen.dart';
import 'loginScreen.dart';
import 'detailsScreen.dart';
import 'splashScreen.dart';
import 'cameraPageScreen.dart';
import 'nativeSplashScreen.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
/* 딥링크 초기화 여부 */
bool _initialURILinkHandled = false;

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  print('main');
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
      //  return const MyApp();
       // return const SplashScreen();
        return const NativeSplashScreen();
      //  return const LogInScreen();
      },
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      name: 'camera',
      path: '/camera',
      builder: (BuildContext context, GoRouterState state) {
        return const CameraPage(param: "카메라");
      },
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LogInScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /* uri dip링크 설정 */
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2
      /*
      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
     */
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("앱최초 실행 Initial URI received $initialURI");
          showToast("앱최초 실행: $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
          //딥링크 파라미터에 따라서 화면 바로가기
         // navigationPage();
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('앱기동중 Received URI: $uri');
        showToast("앱기동중: $uri");
        setState(() {
          _currentURI = uri;
          _err = null;
        });

        //딥링크 파라미터에 따라서 화면 바로가기
       // navigationPage();
        startTime();

        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }
/* 외부 인테트 호출 */
  void createIntent() async {
    if (const LocalPlatform().isAndroid) {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull('https://flutter.dev'),
          package: 'com.android.chrome');
      intent.launch();
    }
  }

  @override
  void initState() {
    super.initState();
   // initialization();
   // _initURIHandler();
   // _incomingLinkHandler();
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
    _initURIHandler();
    _incomingLinkHandler();
  }

  startTime() async {
    // 1초가 지나면 navigationPage 함수가 작동한다.
    debugPrint("스타트 타임 :  $_currentURI");
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    debugPrint("네비게이션 페이지 $_currentURI");
    // 무조건 빌드가 끝난후에 실행하게 한다. WidgetsBinding.instance!.addPostFrameCallback()
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      debugPrint("addPostFrameCallback 페이지 $_currentURI");
      debugPrint("context 페이지 $context");
     // context.goNamed('camera');
      GoRouter.of(context).goNamed('camera');

    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("BuildContext 페이지 $context");
    _incomingLinkHandler();
    return MaterialApp.router(
      routerConfig: _router,
    //  theme: ThemeData.dark().copyWith(
    //    scaffoldBackgroundColor: darkBlue,
    //  ),
      debugShowCheckedModeBanner: false,
      title: 'Go router',
    );
  }
}

void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg, //메세지입력
      toastLength: Toast.LENGTH_LONG, //메세지를 보여주는 시간(길이)
      gravity: ToastGravity.CENTER, //위치지정
      timeInSecForIosWeb: 1, //ios및웹용 시간
      backgroundColor: Colors.black, //배경색
      textColor: Colors.white, //글자색
      fontSize: 16.0 //폰트사이즈
  );
}
