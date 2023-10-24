import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/api/auth_dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_links/uni_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/* 딥링크 초기화 여부 */
bool _initialURILinkHandled = false;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  /* uri dip링크 설정 */
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  TextEditingController emailController =
      TextEditingController(text: "cbw@hello.com");
  TextEditingController passwordController =
      TextEditingController(text: "12345");

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
          debugPrint("로그인 앱최초 실행 Initial URI received $initialURI");
          showToast("앱최초 실행: $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
          //딥링크 파라미터에 따라서 화면 바로가기
          navigationPage();
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
        debugPrint('login앱기동중 Received URI: $uri');
        showToast("앱기동중: $uri");
        setState(() {
          _currentURI = uri;
          _err = null;
        });
        //딥링크 파라미터에 따라서 화면 바로가기
        navigationPage();
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
    //  _initURIHandler();
    //  _incomingLinkHandler();
  }

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    debugPrint("navigationPage initialURI $_initialURI");
    // 무조건 빌드가 끝난후에 실행하게 한다. WidgetsBinding.instance!.addPostFrameCallback()
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.goNamed('home');
      context.pushNamed('camera');
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed: () {})
        ],
      ),
      // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/chef.gif'),
                  width: 170.0,
                ),
              ),
              Form(
                  child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: const InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          TextField(
                            controller: emailController,
                            autofocus: false,
                            decoration: const InputDecoration(labelText: '이메일'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: passwordController,
                            decoration:
                                const InputDecoration(labelText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (emailController.text == '') {
                                    showSnackBar(
                                        context, const Text('이메일을 입력하세요'));
                                    return;
                                  }
                                  if (passwordController.text == '') {
                                    showSnackBar(
                                        context, const Text('비밀번호를 입력하세요'));
                                    return;
                                  }
                                  // 로그인 처리
                                  var dio = await authLoginDio(context);
                                  try {
                                    final response = await dio
                                        .post('/v1/accounts/token', data: {
                                      "username": emailController.text,
                                      "password": passwordController.text
                                    });

                                    Map<String, dynamic> responseMap =
                                        response.data;

                                    print(responseMap);
                                    print(responseMap["success"]);

                                    //response 로 부터 새로 갱신된 AccessToken과 RefreshToken 파싱
                                    final accessToken = response
                                        .headers['Authorization']![0]
                                        .substring(7);
                                    final refreshToken = response
                                        .headers['Refresh']![0]
                                        .substring(7);

                                    print('accessToken: $accessToken');
                                    print('refreshToken: $refreshToken');

                                    //기기에 저장된 AccessToken과 RefreshToken 갱신
                                    await storage.write(
                                        key: 'ACCESS_TOKEN',
                                        value: accessToken);
                                    await storage.write(
                                        key: 'REFRESH_TOKEN',
                                        value: refreshToken);

                                    Get.offNamed('/home');
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                              ))
                        ],
                      );
                    })),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg, //메세지입력
      toastLength: Toast.LENGTH_SHORT, //메세지를 보여주는 시간(길이)
      gravity: ToastGravity.CENTER, //위치지정
      timeInSecForIosWeb: 1, //ios및웹용 시간
      backgroundColor: Colors.black, //배경색
      textColor: Colors.white, //글자색
      fontSize: 16.0 //폰트사이즈
      );
}
