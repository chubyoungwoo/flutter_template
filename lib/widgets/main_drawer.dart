import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  /**
   * Navigator.of(context).pushNamed("/first", arguments: {"title": "Test"});  파라미터 값 넘기기
   * 값받기
   * @override
      Widget build(BuildContext context) {
      Map<String, dynamic> _argument =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      print(_argument["title"]);
      ...
      }
   */
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 300,
                child: Image.asset(
                  'assets/images/profile_bg_01.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                width: 100,
                height: 100,
                child: Image.asset('assets/images/default-user.png'),
              )
            ],
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.home),
            iconColor: Colors.purple,
            focusColor: Colors.red,
            title: const Text('홈',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              context.pop(context);
              context.go('/home');},
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.camera),
            iconColor: Colors.purple,
            focusColor: Colors.red,
            title: const Text('카메라',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              context.pop(context);
              context.push('/camera');
              },
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.mark_as_unread_sharp),
            iconColor: Colors.purple,
            focusColor: Colors.red,
            title: const Text('편지함',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.restore_from_trash),
            iconColor: Colors.purple,
            focusColor: Colors.red,
            title: const Text('휴지통',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            iconColor: Colors.purple,
            focusColor: Colors.red,
            title: const Text('설정',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              context.pop(context);
              context.push('/profile');},
            trailing: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
