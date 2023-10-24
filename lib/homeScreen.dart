import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/foundation.dart';

import 'homePageScreen.dart';
import 'imagePageScreen.dart';
import 'cameraPageScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* uri dip링크 설정 */
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('앱기동중 Received URI: $uri');
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

  void navigationPage() {
    // 위에 설정해 준 것을 바탕으로 2초가 지난후 LoginPage로 이동할수 있게 된다.
    debugPrint("네비게이션 페이지 $_currentURI");

    String path = _currentURI.toString();

    List<String> pathAray = path.split("?");
    print(pathAray);

    debugPrint("패스 " + pathAray[0]);
    debugPrint("패스1 " + pathAray[1].substring(5));

    if (pathAray.length > 1) {
      // Get.offNamed('/');
      Get.toNamed('/${pathAray[1].substring(5)}');
      //Get.toNamed(pathAray[1]);
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CameraPage(param: "카메라"),
    const ImagePage(
      param: "갤러리",
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _incomingLinkHandler();

    print('홈페이지 init 호출');
  }

  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '카메라'),
          BottomNavigationBarItem(
              icon: Icon(Icons.browse_gallery), label: '갤러리')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
