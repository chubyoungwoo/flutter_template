import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  final _baseUrl = 'http://192.168.0.9:8080/api';

  Future<Dio> getClient() async {
    Dio dio = Dio();
    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'content-type': 'text/plain',
    };

    dio.options.headers = headers;
    dio.options.baseUrl = _baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);

    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true)
    );
    return dio;
  }
}