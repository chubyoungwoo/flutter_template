import 'package:flutter/material.dart';
import 'package:flutter_template/widgets/main_drawer.dart';

/**
 * 앱바 없이 작성한 햄버거 버튼
 */
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              const Image(
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/profile_bg_02.jpg'),
              ),
              Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                      icon: const Icon(Icons.menu),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      }
                      )
              ),
              const Positioned(
                  bottom: 10,
                  child: Image(
                    height: 120,
                    width: 120,
                    image: AssetImage('assets/images/default-user.png'),
                    fit: BoxFit.cover,
                  )
              ),

            ],
          ),
          const SizedBox(height: 30.0,),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text('your@email.com'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('000-000-0000'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text('Seoul'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Crossfit'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('God Father Series'),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
      drawer: const MainDrawer(),
    );
  }
}
