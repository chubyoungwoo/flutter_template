import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';

class UserHomePageModel {
  List<User> users;
  UserHomePageModel({required this.users});
}

class UserHomePageViewModel extends StateNotifier<UserHomePageModel?> {
  UserHomePageViewModel(super.state);

  // 초기화 ( 화면 새로 고침 한다면 )
  void init(List<User> postDtoList) {
    state = UserHomePageModel(users: postDtoList);
  }

  // save 기능 추가
  void add(User user) {
    List<User> users = state!.users;
    // 스프레드 연산자로 새로운 컬렉션 생성 - 깊은 복사
    List<User> newUsers = [...users, user]; // 복사 + 추가
    state = UserHomePageModel(users: newUsers);
  }

  // delete
  void remove(int id) {
    List<User> users = state!.users;
    List<User> newUsers = users.where((e) => e.id != id).toList();
    state = UserHomePageModel(users: newUsers);
  }

  // update
  void update(User user) {
    List<User> users = state!.users;
    List<User> newUsers = users.map((e) => e.id == user.id ? user : e).toList();
    state = UserHomePageModel(users: newUsers);
  }
}

final userHomePageProvider =
    StateNotifierProvider<UserHomePageViewModel, UserHomePageModel?>((ref) {
  return UserHomePageViewModel(null);
});
