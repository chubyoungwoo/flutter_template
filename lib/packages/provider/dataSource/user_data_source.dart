import 'package:flutter/material.dart';
import 'package:flutter_template/api/auth_dio.dart';
import '../model/user_model.dart';

/* api 연동 */
class UserDataSource {
  Future<List<UserModel>?> getUserList() async {
    var dio = await authDio();
    final response = await dio.get(
      '/v1/accounts/userList',
    );

    debugPrint("user : ${response.data}");

    //Map<String, dynamic> responseMap = response.data;
    List<dynamic> responseMap = response.data;

    print(responseMap);

    //final List<String> strs = responseMap.map((json) => json.toString()).toList();

    final List<UserModel> model =
        responseMap.map((json) => UserModel.fromJson(json)).toList();

    print('list===========');

    print(model);

    print(model[0]);

    print(model[0].id);
    print(model[0].authorities);

    //responseMap.map<UserModel>(json) => UserModel.fromJson(json);

    //var kk = responseMap.forEach((element) => UserModel.fromJson(element));

    //debugPrint('kk : $kk');

    // var userModel = UserModel.fromJson(responseMap);

    //debugPrint('userModel : $userModel');

    // responseMap.map<UserModel>((json) => UserModel.fromJson(json)).toList();
    return model;
  }
}
