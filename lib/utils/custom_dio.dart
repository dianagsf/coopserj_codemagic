import 'package:dio/dio.dart';

class CustomDio {
  var _dio;

  //http://54.207.211.41:3100
  //http://192.168.0.107:3100

  CustomDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://54.207.211.41:3100',
        connectTimeout: 10000,
      ),
    );
  }

  Dio get instance => _dio;
}
