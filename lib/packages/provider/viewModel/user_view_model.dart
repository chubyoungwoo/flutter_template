import 'package:flutter/material.dart';
import 'package:flutter_template/packages/provider/model/user_model.dart';
import 'package:flutter_template/packages/provider/repository/user_repository.dart';

class UserViewModel with ChangeNotifier {
  late final UserRepository _userRepository;
  List<UserModel>? _userList = List.empty(growable: true);
  List<UserModel>? get userList => _userList;

  UserViewModel() {
    _userRepository = UserRepository();
    _getUserList();
  }

  Future<void> _getUserList() async {
    _userList = await _userRepository.getUserList();
    notifyListeners();
  }
}
