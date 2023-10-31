import 'package:flutter/material.dart';
import 'package:flutter_template/packages/provider/dataSource/user_data_source.dart';
import 'package:flutter_template/packages/provider/model/user_model.dart';

class UserRepository {
  final UserDataSource _dataSource = UserDataSource();

  Future<List<UserModel>?> getUserList() {
    return _dataSource.getUserList();
  }
}
