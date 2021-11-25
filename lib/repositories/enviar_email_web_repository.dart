import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class EnviarEmailWebRepository {
  Future<int> enviarEmailWeb(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/enviaEmailWEB', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> enviarEmailSenhaWeb(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/enviaEmailSenhaWeb', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
