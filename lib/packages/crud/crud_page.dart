import 'package:flutter/material.dart';

import '../../api/auth_dio.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  createState() => _CrudState();
}

class _CrudState extends State<CrudPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('CRUD 테스트'),
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children:  <Widget>[
                    ElevatedButton(
                        onPressed: () async {
                          var dio = await authDio(context);
                          try {
                            final response = await dio.get(
                                '/user',
                             );
                            print("user :" + response.data);

                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('조회'),
                    ),
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