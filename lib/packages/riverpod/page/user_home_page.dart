import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/packages/riverpod/model/user.dart';

import '../controller/user_controller.dart';
import 'user_home_page_view_model.dart';

class UserHomePage extends ConsumerWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserController uc = ref.read(userController);
    UserHomePageModel? um = ref.watch(userHomePageProvider); //Provider를 감시

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: um != null ? buildListView(um.users) : buildListView([]),
          //  buildButton(uc.findUsers()), //버튼
        ),
        ElevatedButton(
          onPressed: () {
            uc.findUsers();
          },
          child: const Text('조회'),
        ),
        ElevatedButton(
          onPressed: () {
            uc.removeUser(1);
          },
          child: const Text('한건삭제'),
        ),
        ElevatedButton(
          onPressed: () {
            uc.addUser('신규추가');
          },
          child: const Text('한건추가'),
        ),
        ElevatedButton(
          onPressed: () {
            User updateUser = User();
            updateUser.id = 4;
            updateUser.title = '제목2';

            uc.updateUser(updateUser);
          },
          child: const Text('한건수정'),
        ),
      ]),
    );
  }

  Widget buildListView(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.green[100]),
              height: 100,
              child: ListTile(
                leading: Text("${users[index].id}"),
                title: Text("${users[index].title}"),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
