class UserModel {
  int id;
  String username;
  String password;
  int tokenWeight;
  String nickname;
  bool activated;
  String? refreshToken;
  List<dynamic> authorities;

  UserModel(
      {required this.id,
      required this.username,
      required this.password,
      required this.tokenWeight,
      required this.nickname,
      required this.activated,
      this.refreshToken,
      required this.authorities});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      tokenWeight: json['tokenWeight'],
      nickname: json['nickname'],
      activated: json['activated'],
      authorities: json['authorities'],
    );
  }
}
