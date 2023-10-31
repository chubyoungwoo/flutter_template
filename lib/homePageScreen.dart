import 'package:flutter/material.dart';
import 'widgets/main_drawer.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('홈페이지'),
        elevation: 0.0,
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/riverpod');
                      },
                      child: const Text('RiverPod'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/retrofit');
                      },
                      child: const Text('Retrofit'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/provider');
                      },
                      child: const Text('Provider'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
