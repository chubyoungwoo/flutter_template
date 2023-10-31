import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/packages/riverpod/page/user_home_page_view_model.dart';
import '../model/user.dart';
import '../model/user_repository.dart';

final userController = Provider<UserController>((ref) {
  return UserController(ref);
});

class UserController {
  Ref ref;
  UserController(this.ref);

  Future<void> findUsers() async {
    List<User> homePageUserDto = await UserRepository().findAll();
    ref.read(userHomePageProvider.notifier).state =
        UserHomePageModel(users: homePageUserDto);
  }

  Future<void> addUser(String title) async {
    User user = await UserRepository().save(title);
    ref.read(userHomePageProvider.notifier).add(user);
  }

  Future<void> removeUser(int id) async {
    UserRepository().deleteById(id);
    ref.read(userHomePageProvider.notifier).remove(id);
  }

  Future<void> updateUser(User user) async {
    User userPS = await UserRepository().update(user);
    ref.read(userHomePageProvider.notifier).update(userPS);
  }
}
