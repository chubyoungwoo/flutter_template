import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'homePageScreen.dart';
import 'imagePageScreen.dart';
import 'cameraPageScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold
  );

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CameraPage(param: "카메라"),
    const ImagePage(param: "갤러리",),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: '카메라'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.browse_gallery),
              label: '갤러리'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),

    );
  }

  @override
  void initState() {
    // 해당 클래스가 호출되었을때
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

