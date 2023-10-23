import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
/*
  함수의 인자로 BuildContext를 따로 받는 이유는 Dialog를 사용해 로그인 만료를 알리거나 Navigator를 통해 로그인 재요청 페이지로 이동하려면 현재 사용자가 머물고 있는
  화면의 context가 필요하기 때문이다. 또한 요청하는 API의 도메인이 항상 같다면 baseUrl 속성을 본 dio 객체에 부여할 수도 있다.
  최종적으로 반환하는 dio 객체가 하는 일
  매 요청마다 헤더에 AccessToken 추가
  인증 오류(401) 발생 시 RefreshToken을 담아 토큰 갱신 API 요청
  토큰 갱신 성공 시 새로운 AccessToken으로 교체하여 기존 API 재요청
  RefreshToken 만료로 인해 토큰 갱신 실패 시 로그인 재요청
 */
Future<Dio> authDio(BuildContext context) async {
  var dio = Dio();
  final _baseUrl = 'http://192.168.0.9:8080/api';

  final storage = new FlutterSecureStorage();

  dio.options.baseUrl = _baseUrl;
  dio.options.connectTimeout = const Duration(milliseconds: 5000);
  dio.options.receiveTimeout = const Duration(milliseconds: 5000);
  dio.interceptors.clear();

  /* 인터셋터 처리 */
  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {  //매요청시
        // 기기에 저장된 AccessToken 코드
        final accessToken = await storage.read(key : 'ACCESS_TOKEN');

          print('accessToken: $accessToken');

        // 매 요청마다 헤더에 AccessToken을 포함
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {  //에러발생시
        //인증 오류가 발생했을 경우 : AccessToken의 만료
        print('AccessToken의 만료 : ' );
        print( error.response?.statusCode);
        if (error.response?.statusCode == 401) {
          // 기기에 저장된 AccessToken과 RefreshToken 로드
          final accessToken = await storage.read(key: 'ACCESS_TOKEN');
          final refreshToken = await storage.read(key: 'REFRESH_TOKEN');
          // 토큰 갱신 요청을 담당할 DIO 객체 구현 후 그에 따른 interceptor 정의
          var refreshDio = Dio();
          refreshDio.interceptors.clear();
          refreshDio.interceptors.add(InterceptorsWrapper(
            onError: (error, handler) async {
              // 다시 인증 오류가 발생했을 경우 : RefreshToken의 만료
              print('RefreshToken의 만료 : ' );
              print(error.response?.statusCode);
              if( error.response?.statusCode == 403 || error.response?.statusCode == 500) {
                // 기기의 저동 로그인 정보 삭제
                await storage.deleteAll();
                showToast("토큰이 만료 되었습니다.");
                // 로그인 만료 창 발생후 로그인 페이지로 이동
                Get.offNamed('/login');

              }
              return handler.next(error);
            }
          ));
          // 토큰 갱신 API 요청시 AccessToken(만료), RefreshToken 포함
          refreshDio.options.headers['Authorization'] = 'Bearer $accessToken';
          refreshDio.options.headers['Refresh'] = 'Bearer $refreshToken';
          refreshDio.options.baseUrl = _baseUrl;
          refreshDio.options.connectTimeout = const Duration(milliseconds: 5000);
          refreshDio.options.receiveTimeout = const Duration(milliseconds: 5000);
          // 토큰 갱신 API 요청
          final refreshResponse = await refreshDio.put('/v1/accounts/refresh');
          //response 로 부터 새로 갱신된 AccessToken과 RefreshToken 파싱
          final newAccessToken = refreshResponse.headers['Authorization']![0].substring(7);
          final newRefreshToken = refreshResponse.headers['Refresh']![0].substring(7);

          print ('newAccessToken: $newAccessToken');
          print ('newRefreshToken: $newRefreshToken');
          //기기에 저장된 AccessToken과 RefreshToken 갱신
          await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
          await storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);

          //AccessToken의 만료로 수행하지 못했던 API요청에 담겼던 AccessToken 갱신
          error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          //수행하지 못했던 API 요청 복사복 생성
          final clonedRequest = await dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters
                  );

          // API 복사본으로 재요청
          return handler.resolve(clonedRequest);

        }
        return handler.next(error);
      }
    ));

    /* 로그 처리 */
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true)
    );

   return dio;
}

void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg, //메세지입력
      toastLength: Toast.LENGTH_LONG, //메세지를 보여주는 시간(길이)
      gravity: ToastGravity.CENTER, //위치지정
      timeInSecForIosWeb: 1, //ios및웹용 시간
      backgroundColor: Colors.black, //배경색
      textColor: Colors.white, //글자색
      fontSize: 16.0 //폰트사이즈
  );
}