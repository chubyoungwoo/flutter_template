import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/pages/rootPage.dart';
import 'package:flutter_template/routes/route.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_template/screens/profileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/api/auth_dio.dart';

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
  runApp(MyApp());
}

/// The route configuration.
/*
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
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: routes,
      //  home: const RootPage()
      home: const MyRoute(),
    );
  }
}

class MyRoute extends StatefulWidget {
  const MyRoute({super.key});

  @override
  _MyRouteState createState() => _MyRouteState();
}

class _MyRouteState extends State<MyRoute> {
  /* uri dip링크 설정 */
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;
  bool _dipLink = false;

  String userInfo = ""; //user의 정보를 저장하기 위한 변수
  static const storage =
      FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

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
          // showToast("앱최초 실행: $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
            _currentURI = initialURI;
            _dipLink = true;
          });
          //딥링크 파라미터에 따라서 화면 바로가기
          //navigationPage();
          startTime();
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
          _dipLink = true;
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
    initialization();
    // _initURIHandler();
    // _incomingLinkHandler();

    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    print('메인 init 호출');
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    //userInfo = (await storage.read(key: "login"));
    //print(userInfo);
    print("최초앱기동 두번호출");
    // 로그인 인증 키가 유효한지 체크 유효하면 자동 로그인 아니면 로그인 페이지로
    // 기기에 저장된 AccessToken 코드
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');

    print("====================================");
    print(accessToken);
    print(_dipLink);
    print("====================================");

    if (accessToken != null && !_dipLink) {
      //보안상 무조건 액세스토큰과 리플레쉬 토큰을 재발급한다.

      // 토큰 갱신 API 요청
      var dio = await authAutoLoginDio();
      final refreshResponse = await dio.put('/v1/accounts/refresh');
      //response 로 부터 새로 갱신된 AccessToken과 RefreshToken 파싱
      final newAccessToken =
          refreshResponse.headers['Authorization']![0].substring(7);
      final newRefreshToken =
          refreshResponse.headers['Refresh']![0].substring(7);

      print('자동로그인 newAccessToken: $newAccessToken');
      print('자동로그인 newRefreshToken: $newRefreshToken');
      //기기에 저장된 AccessToken과 RefreshToken 갱신
      await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
      await storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);

      Get.offNamed('/home');
    }

    if (accessToken == null && !_dipLink) {
      Get.offNamed('/login');
    }

    // print(_dipLink);
    //user의 정보가 있다면 바로 홈 페이지로 넝어가게 합니다.
    //if (userInfo != null && !_dipLink) {
    //  Get.offNamed('/home');
    //}
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
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    debugPrint("네비게이션 페이지 $_currentURI");
    // 무조건 빌드가 끝난후에 실행하게 한다. WidgetsBinding.instance!.addPostFrameCallback()
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    debugPrint("addPostFrameCallback 페이지 $_currentURI");
    debugPrint("context 페이지 $context");
    // context.goNamed('camera');

    print('창이 죽은경우 _initialURI : ' + _initialURI.toString());
    print('창 이 살아 있는경우_currentURI : ' + _currentURI.toString());

    String path = _currentURI.toString();

    List<String> pathAray = path.split("?");
    print(pathAray);

    debugPrint("패스 " + pathAray[0]);
    debugPrint("패스1 " + pathAray[1].substring(5));

    //debugPrint("패스$pathAray[0]");

    if (pathAray.length > 1) {
      // Get.offNamed('/');
      Get.offNamed('/home');
      Get.toNamed('/${pathAray[1].substring(5)}');
      //Get.toNamed(pathAray[1]);
    }

    //  Get.toNamed('/splash');
    // Get.toNamed('/login');
    // Get.offNamed('/home');
    //  Get.toNamed('/camera');
    // GoRouter.of(context).goNamed('camera');

    // });
  }

  @override
  void dispose() {
    debugPrint("네비게이션 dispose $_currentURI");

    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BuildContext _dipLink $_dipLink");
    return MaterialApp(
        // routerConfig: _router,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBlue,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Go router',
        // home: const Scaffold(
        //   body: Column(
        //     children: [
        //       Padding(padding: EdgeInsets.only(top: 50)),
        //       Center(
        //         child: Image(
        //           image: AssetImage('assets/images/splash.jpg'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        home: const NativeSplashScreen()
        // home: _dipLink ? const HomeScreen() : const NativeSplashScreen(),
        //    home: _dipLink ? const HomeScreen() : const RootPage(),
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
