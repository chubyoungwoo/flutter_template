import 'package:flutter/material.dart';
import 'widgets/main_drawer.dart';

class CameraPage extends StatefulWidget {
  final String param;
  const CameraPage({super.key, required this.param});
  @override
  createState() => _CameraState();
}

class _CameraState extends State<CameraPage> {


  @override
  Widget build(BuildContext context) {

    String title = widget.param;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(title),
      ),
      //drawer: const MainDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Image.asset('assets/images/dog.png'))
                  ],
                ) ,
              )
            ],
          ),
        ),
      ),
    );
   
  }
  
}