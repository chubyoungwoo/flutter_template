import 'package:flutter/material.dart';
import 'package:flutter_template/packages/provider/viewModel/user_view_model.dart';
import "package:provider/provider.dart";
import 'package:flutter_template/packages/provider/model/user_model.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});
  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late List<UserModel>? userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MVVM 연습"),
        ),
        body: Consumer<UserViewModel>(
          builder: (context, provider, child) {
            userList = provider.userList;
            return ListView.builder(
                itemCount: userList!.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                          "${userList![index].username} : ${userList![index].password}"));
                });
          },
        ));
  }
}
