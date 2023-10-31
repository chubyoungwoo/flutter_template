import 'user.dart';

class UserRepository {
  //싱글톤 생성
  static final UserRepository _instance = UserRepository._single();
  UserRepository._single(); //기본생성자

  factory UserRepository() {
    // factory가 메모리에 주소가 없다면 새로 만들고 있다면 재사용한다.
    return _instance;
  }

// DB는 생략함, 더미데이터를 만들어 데이터를 송수신한다고 가정 !!
  Future<List<User>> findAll() {
    return Future.delayed(Duration(seconds: 1), () {
      // I/O에 1초가 걸렸다고 가정
      return [
        User(id: 1, title: "제목1"),
        User(id: 2, title: "제목2"),
        User(id: 3, title: "제목3"),
      ];
    });
  }

// save할때 데이터 영속화 -> REST API를 통해 저장된 데이터를 반환받음
  Future<User> save(String title) {
    return Future.delayed(Duration(seconds: 1), () {
      return User(id: 4, title: title); // id는 임의 - 자동생성키로 가정
    });
  }

  Future<void> deleteById(int id) {
    return Future.delayed(Duration(seconds: 1));
  }

  // 마찬가지로 save -> 영속화 객체 존재(더티체킹) or update -> 데이터 반환
  Future<User> update(User user) {
    return Future.delayed(Duration(seconds: 1), () {
      return user;
    });
  }
}
